"""Stream one explicitly passed UART device to stdout (container helper)."""
import os,select,sys,termios,tty,signal
signal.signal(signal.SIGTERM,lambda *_:sys.exit(0))
fd=os.open(sys.argv[1],os.O_RDWR|os.O_NOCTTY|os.O_NONBLOCK)
tty.setraw(fd);cfg=termios.tcgetattr(fd)
cfg[2]=(cfg[2]&~(termios.CSIZE|termios.PARENB|termios.CSTOPB|termios.CRTSCTS))|termios.CS8|termios.CLOCAL|termios.CREAD
cfg[4]=cfg[5]=termios.B115200;termios.tcsetattr(fd,termios.TCSANOW,cfg)
termios.tcflush(fd,termios.TCIFLUSH)
os.write(1,b'ISAAC_UART_READY\n')
while True:
 ready,_,_=select.select([fd],[],[],1)
 if ready:
  try:data=os.read(fd,65536)
  except BlockingIOError:continue
  if data:os.write(1,data)
