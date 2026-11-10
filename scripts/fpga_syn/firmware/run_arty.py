"""Capture UART before volatile Arty programming; retain execution evidence."""
import argparse
import fcntl
import json
import os
import math
import re
import struct
from pathlib import Path
import select
import subprocess
import termios
import time
import tty

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('bitstream',type=Path);p.add_argument('output',type=Path)
p.add_argument('--board-serial',default='210319C08AE1')
p.add_argument('--port',default='/dev/serial/by-id/usb-Digilent_Digilent_USB_Device_210319C08AE1-if01-port0')
p.add_argument('--vivado',default='/nfs/tools/xilinx/Vivado/2024.1/bin/vivado')
p.add_argument('--uart-container',help='Existing image with Python3; pass only this UART into a non-root container')
p.add_argument('--program-script',type=Path,help='Alternative guarded programming/debug Tcl script')
p.add_argument('--timeout',type=float,default=240)
p.add_argument('--protocol',choices=['probe','mlonmcu'],default='probe')
p.add_argument('--boot-banner',default='ISAAC CVA5 BOOT')
p.add_argument('--expected-results',type=Path,help='Numerical results JSON containing a samples list')
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
bit=a.bitstream.resolve();out=a.output.resolve()
stream=None;old=None;proc=None
if a.uart_container:
 device=str(Path(a.port).resolve());group=os.stat(device).st_gid
 helper=Path(__file__).with_name('uart_stream.py').resolve()
 stream=subprocess.Popen(['docker','run','--rm','--device',device+':/dev/isaac_uart','--user',str(os.getuid())+':'+str(os.getgid()),'--group-add',str(group),'-v',str(helper)+':/uart_stream.py:ro','--entrypoint','python3',a.uart_container,'/uart_stream.py','/dev/isaac_uart'],stdout=subprocess.PIPE)
 fd=stream.stdout.fileno();ready=b'';deadline=time.monotonic()+30
 while b'ISAAC_UART_READY\n' not in ready and time.monotonic()<deadline:
  if select.select([fd],[],[],1)[0]:
   chunk=os.read(fd,65536)
   if not chunk:raise RuntimeError('UART capture container exited before readiness')
   ready+=chunk
 if b'ISAAC_UART_READY\n' not in ready:raise RuntimeError('UART capture did not become ready')
else:
 fd=os.open(a.port,os.O_RDWR|os.O_NOCTTY|os.O_NONBLOCK)
 fcntl.flock(fd,fcntl.LOCK_EX|fcntl.LOCK_NB)
 old=termios.tcgetattr(fd)
try:
 if stream is None:
  tty.setraw(fd)
  cfg=termios.tcgetattr(fd)
  cfg[2]=(cfg[2]&~(termios.CSIZE|termios.PARENB|termios.CSTOPB|termios.CRTSCTS))|termios.CS8|termios.CLOCAL|termios.CREAD
  cfg[4]=cfg[5]=termios.B115200
  termios.tcsetattr(fd,termios.TCSANOW,cfg);termios.tcflush(fd,termios.TCIFLUSH)
 script=(a.program_script or Path(__file__).with_name('program_arty.tcl')).resolve()
 command=[a.vivado,'-mode','batch','-source',str(script),'-tclargs',a.board_serial,str(bit)]
 raw=bytearray();started=time.monotonic();finished=None
 with (out/'program.stdout.log').open('wb') as log:
  proc=subprocess.Popen(command,cwd=out,stdout=log,stderr=subprocess.STDOUT)
  while time.monotonic()-started<a.timeout:
   ready,_,_=select.select([fd],[],[],0.2)
   if ready:
    try: data=os.read(fd,65536)
    except BlockingIOError: data=b''
    raw.extend(data)
    (out/'uart.bin').write_bytes(raw)
   result=proc.poll()
   if result is not None:
    if finished is None: finished=time.monotonic()
    # Keep capturing after configuration, including slow firmware failures.
    text=raw.decode('utf-8',errors='replace')
    done=any(line.strip() in ('PASS','FAIL') or line.startswith('MLONMCU EXIT:') for line in text.splitlines())
    if (done and time.monotonic()-finished>1) or time.monotonic()-finished>15: break
  if proc.poll() is None:
   proc.terminate()
   try: proc.wait(timeout=10)
   except subprocess.TimeoutExpired: proc.kill();proc.wait()
 text=raw.decode('utf-8',errors='replace');(out/'uart.log').write_text(text)
 lines=text.splitlines()
 programmed=proc.returncode==0 and 'ISAAC_PROGRAMMED=' in (out/'program.stdout.log').read_text(errors='replace')
 if a.protocol=='probe':
  passed=programmed and a.boot_banner in text and any(l.strip()=='PASS' for l in lines) and not any('FAIL' in l or 'TRAP' in l for l in lines)
 else:
  passed=programmed and 'Program finish.' in text and any(l.strip()=='MLONMCU EXIT: 0' for l in lines) and not any('TRAP' in l for l in lines)
 numerical=None
 if a.expected_results:
  expected=json.loads(a.expected_results.read_text())
  samples=expected['samples']
  frames=re.findall(rb'-\?-(.{4})-!-',bytes(raw),re.S)
  values=[struct.unpack('<f',v)[0] for v in frames]
  atol=expected.get('atol',1e-6);rtol=expected.get('rtol',1e-6)
  valid=len(values)==len(samples) and all(math.isfinite(v) and abs(v-r['reference'])<=atol+rtol*abs(r['reference']) for v,r in zip(values,samples))
  numerical={'passed':valid,'outputs':values,'atol':atol,'rtol':rtol}
  passed=passed and valid

 report={'passed':passed,'protocol':a.protocol,'numerical':numerical,'program_returncode':proc.returncode,'board_serial':a.board_serial,'port':a.port,'baudrate':115200,'bitstream':str(bit),'uart':text,'elapsed_seconds':time.monotonic()-started,'programming':'volatile FPGA configuration; no flash'}
 (out/'execution.json').write_text(json.dumps(report,indent=2)+'\n')
 print(text,flush=True)
 print(json.dumps({k:v for k,v in report.items() if k!='uart'},indent=2),flush=True)
 raise SystemExit(0 if passed else 1)
finally:
 if proc is not None and proc.poll() is None: proc.terminate()
 if stream is None:
  termios.tcsetattr(fd,termios.TCSANOW,old);os.close(fd)
 else:
  stream.terminate()
  try: stream.wait(timeout=10)
  except subprocess.TimeoutExpired: stream.kill();stream.wait()
