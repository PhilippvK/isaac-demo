"""Exercise independent F4PGA dispatch, native-result validation and open memory."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
from types import SimpleNamespace

import pytest

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('fpga_f4', ROOT/'scripts/fpga_syn/f4pga/run.py')
f4 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(f4)


def source_tree(tmp_path):
    rtl = tmp_path/'input'
    rtl.mkdir()
    (rtl/'files.txt').write_text('VexRiscv.v\nVex_top.sv\n')
    (rtl/'VexRiscv.v').write_text('module VexRiscv(input clk);\nwire                writeBack_arbitration_isFiring;\nendmodule\n')
    (rtl/'Vex_top.sv').write_text('module top(input clk);\n VexRiscv VexRiscv_inst(.clk(clk));\nendmodule\n')
    (rtl/'defs.svh').write_text('`define EXAMPLE 1\n')
    (tmp_path/'ISAX_XIsaac.sv').write_text('module ISAX_XIsaac; endmodule\n')
    return rtl


def native_outputs(out, setup=-1.25, hold=None):
    out.mkdir(exist_ok=True, parents=True)
    cells = {str(i): {'type': t} for i, t in enumerate(['LUT6', 'LUT2', 'FDRE_ZINI', 'RAMB36E1_VPR'])}
    (out/'vex_arty_top.json').write_text(json.dumps({'modules': {'vex_arty_top': {'cells': cells,'netnames': {'clk100': {'bits':[1]},'clk20': {'bits':[2]}}}}}))
    (out/'vex_arty_top.sdc').write_text('create_clock -period 10 clk100\ncreate_clock -period 50.000 clk20\n')
    f4.deduplicate_sdc(out)
    (out/'route.log').write_text(f'Final setup slack (sWNS): {setup} ns\n'+
                                 (f'Final hold slack (hWNS): {hold} ns\n' if hold is not None else ''))
    for suffix in ['eblif', 'net', 'place', 'route', 'fasm', 'bit']:
        (out/('vex_arty_top.'+suffix)).write_text('fixture\n')
    (out/'vex_arty_top.fasm').write_text('CLBLL_L_X1Y1.SLICEL_X0.ALUT.INIT[0]\nBRAM_L_X2Y1.RAMB36.IN_USE\n')


def completed(out,setup=-1.25,hold=None):
    native_outputs(out,setup,hold)
    (out/'metrics.json').write_text(json.dumps(f4.parse_results(out)))
    meta = dict(passed=True, status='complete', tool='f4pga', core='VEX_5S',
                part=f4.PART, board='arty_a7_100', clock_period_ns=50, completed_steps=f4.STEPS, frontend_checked=True)
    meta['artifacts_sha256'] = {p.name:f4.sha(p) for p in out.iterdir() if p.is_file()}
    (out/'execution.json').write_text(json.dumps(meta))
    return meta


def test_prepare_stages_extension_headers_and_explicit_retirement(tmp_path):
    rtl = source_tree(tmp_path)
    out = tmp_path/'out'; out.mkdir()
    original = (rtl/'VexRiscv.v').read_bytes()
    sources, hashes = f4.prepare(rtl, out)
    assert 'rtl/ISAX_XIsaac.sv' in sources
    assert (out/'rtl/defs.svh').is_file()
    shell=(out/'rtl/vex_arty_top.sv').read_text()
    assert 'dut.VexRiscv_inst.' not in shell
    assert 'PLLE2_ADV #(' in shell and 'MMCME2_BASE #(' not in shell
    assert '.CLKINSEL(1\'b1)' in shell and '.DWE(1\'b0)' in shell
    assert '.isaac_retired(isaac_retired)' in (out/'rtl/Vex_top.sv').read_text()
    assert (rtl/'VexRiscv.v').read_bytes() == original
    assert hashes[str(rtl/'VexRiscv.v')] == hashlib.sha256(original).hexdigest()


def test_firmware_little_endian_and_size(tmp_path):
    binary=tmp_path/'fw.bin'; binary.write_bytes(b'\x12\x34\x56\x78\xff')
    lines=f4.firmware_image(binary).splitlines()
    assert len(lines)==65536 and lines[:2]==['78563412','000000ff']
    coe=tmp_path/'fw.coe';coe.write_text('memory_initialization_radix=16;\nmemory_initialization_vector=78563412,ff;\n')
    assert f4.firmware_image(coe=coe)==f4.firmware_image(binary)
    binary.write_bytes(b'')
    with pytest.raises(ValueError): f4.firmware_image(binary)
    with pytest.raises(ValueError): f4.firmware_image(binary,coe)


def test_memory_byte_writes_sync_read_and_enable(tmp_path):
    if not shutil.which('iverilog'): pytest.skip('Icarus is not installed')
    (tmp_path/'firmware.hex').write_text('12345678\n'+'00000000\n'*65535)
    (tmp_path/'test.sv').write_text('''module tb;
reg clk=0; always #5 clk=~clk;
reg ena=1,enb=0; reg[3:0] web=0;reg[31:0] dinb=0;
wire[31:0] a,b;
blk_mem_gen_0 ram(clk,ena,4'b0,16'b0,32'b0,a,clk,enb,web,16'b0,dinb,b);
initial begin
 #6; if(a!==32'h12345678) $fatal(1,"initial synchronous read");
 ena=0;enb=1;web=4'b0101;dinb=32'hdeadbeef;
 #10; if(b!==32'h12ad56ef) $fatal(1,"byte enables/write-first");
 web=0; #10; if(b!==32'h12ad56ef) $fatal(1,"stored data");
 if(a!==32'h12345678) $fatal(1,"disabled read holds output");
 ena=1;#10;if(a!==32'h12ad56ef) $fatal(1,"port A sees port B write");
 $display("PASS");$finish;
end
endmodule\n''')
    subprocess.run(['iverilog','-g2012','-s','tb','-o','sim',str(ROOT/'scripts/fpga_syn/f4pga/ram.sv'),'test.sv'],cwd=tmp_path,check=True)
    result=subprocess.run(['vvp','sim'],cwd=tmp_path,check=True,capture_output=True,text=True)
    assert 'PASS' in result.stdout


def test_native_metrics_keep_mapping_and_timing_separate(tmp_path):
    native_outputs(tmp_path)
    metrics=f4.parse_results(tmp_path)
    assert metrics['luts_total']==2 and metrics['brams_18k_equivalent']==2
    assert not metrics['setup_met'] and metrics['hold_met'] is None


@pytest.mark.parametrize('failure',['missing_route','missing_clock','unmapped','missing_bit','nonfinite'])
def test_incomplete_native_results_rejected(tmp_path,failure):
    native_outputs(tmp_path)
    if failure=='missing_route': (tmp_path/'route.log').write_text('Routing failed')
    if failure=='missing_clock': (tmp_path/'vex_arty_top.sdc').write_text('create_clock -period 10 clk100')
    if failure=='unmapped':
        p=tmp_path/'vex_arty_top.json';p.write_text(p.read_text().replace('LUT6','$add'))
    if failure=='missing_bit': (tmp_path/'vex_arty_top.bit').unlink()
    if failure=='nonfinite': (tmp_path/'route.log').write_text('Final setup slack (sWNS): 1e999 ns')
    with pytest.raises(ValueError): f4.parse_results(tmp_path)


def test_cache_identity_and_tamper_rejected(tmp_path):
    completed(tmp_path)
    assert not f4.validate(tmp_path)['setup_met']
    with pytest.raises(ValueError): f4.validate(tmp_path,clock=10)
    with pytest.raises(ValueError): f4.validate(tmp_path,part='other')
    (tmp_path/'vex_arty_top.bit').write_bytes(b'tampered')
    with pytest.raises(ValueError): f4.validate(tmp_path)


def test_stale_success_and_unsupported_target_fail_before_tools(tmp_path):
    rtl=source_tree(tmp_path);out=tmp_path/'out';completed(out)
    args=SimpleNamespace(output=out,rtl=rtl,core='VEX_5S',board='arty_a7_100',part=f4.PART,clock_ns=50,timeout=10)
    assert not f4.run(args)
    assert not json.loads((out/'execution.json').read_text())['passed']
    args.output=tmp_path/'unsupported';args.core='UNSUPPORTED'
    assert not f4.run(args)
    assert 'currently supports' in json.loads((args.output/'execution.json').read_text())['error']


def test_six_commands_use_generated_sdc_and_full_100t_device():
    commands=f4.commands(['rtl/core.sv'])
    assert len(commands)==6 and commands[0][0]=='symbiflow_synth'
    for cmd in commands[1:5]:
        assert 'xc7a100t_test' in cmd and 'constraints.sdc' in cmd
    assert f4.PART in commands[-1]


def test_flow_cache_preservation_and_backend_mismatch(tmp_path):
    cache=tmp_path/'cache';completed(cache)
    output=tmp_path/'experiment'
    env=dict(os.environ,ASIP_SYN_ENABLE='0',FPGA_SYN_ENABLE='1',FPGA_SYN_TOOL='symbiflow',
             FPGA_SYN_F4PGA_CORE_NAME='VEX_5S',FPGA_SYN_BASELINE_USE=str(cache),FPGA_SYN_SKIP_DEFAULT='1',FPGA_SYN_SKIP_SHARED='1',
             FPGA_SYN_PYTHON=sys.executable,USE_HLS_DOCKER='0',FILTERED2='1',SELECTED='1')
    result=subprocess.run(['bash',str(ROOT/'scripts/flow_syn.sh'),str(output)],env=env,capture_output=True,text=True)
    assert result.returncode==0,result.stdout+result.stderr
    evidence=output/'fpga_syn_f4pga_filtered2_selected'
    assert (evidence/'metrics.csv').is_file()
    assert f4.validate(evidence/'baseline')['luts_total']==2
    env['FPGA_SYN_TOOL']='vivado'
    result=subprocess.run(['bash',str(ROOT/'scripts/flow_syn.sh'),str(output)],env=env,capture_output=True,text=True)
    assert result.returncode!=0 and 'cannot be used as a Vivado' in result.stderr


def test_f4pga_native_lut_atoms_are_not_unmapped(tmp_path):
    native_outputs(tmp_path)
    p=tmp_path/'vex_arty_top.json';p.write_text(p.read_text().replace('LUT6','$lut'))
    metrics=f4.parse_results(tmp_path)
    assert metrics['luts_total']==2
    assert 'not Vivado' in metrics['resource_stage']


def test_programmer_is_serial_selected_and_volatile_only():
    spec=importlib.util.spec_from_file_location('programmer',ROOT/'scripts/fpga_syn/firmware/programmer.py')
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    cmd=mod.command('openfpgaloader','design.bit','TEST123','vivado','program.tcl')
    assert '--usb-serial-num' in cmd and 'TEST123' in cmd and 'arty_a7_100t' in cmd
    assert '-f' not in cmd and '--write-flash' not in cmd
    with pytest.raises(ValueError):mod.command('openfpgaloader','design.bit','bad serial','vivado','program.tcl')


def test_backend_requires_every_step_and_captures_tool_failure(tmp_path,monkeypatch):
    rtl=source_tree(tmp_path)
    args=SimpleNamespace(output=tmp_path/'out',rtl=rtl,core='VEX_5S',board='arty_a7_100',
                         part=f4.PART,clock_ns=50,timeout=10,firmware=None,coe=None,launcher='',env_script=None)
    calls=[]
    def invoke(cmd,**kwargs):
        calls.append(cmd)
        if cmd[0]=='symbiflow_synth':native_outputs(args.output)
        if cmd[0]=='symbiflow_route':
            raise subprocess.CalledProcessError(1,cmd)
    monkeypatch.setattr(f4.subprocess,'run',invoke)
    assert not f4.run(args)
    meta=json.loads((args.output/'execution.json').read_text())
    assert meta['completed_steps']==['synth','pack','place']
    assert not meta['passed'] and not any(c[0]=='symbiflow_write_bitstream' for c in calls)


def test_backend_full_sequence_preserves_native_evidence(tmp_path,monkeypatch):
    rtl=source_tree(tmp_path)
    args=SimpleNamespace(output=tmp_path/'out',rtl=rtl,core='VEX_5S',board='arty_a7_100',
                         part=f4.PART,clock_ns=50,timeout=10,firmware=None,coe=None,launcher='',env_script=None)
    def invoke(cmd,**kwargs):
        if cmd[0]=='symbiflow_synth':native_outputs(args.output,setup=2.5,hold=0.1)
    monkeypatch.setattr(f4.subprocess,'run',invoke)
    assert f4.run(args)
    assert f4.validate(args.output)['setup_met']
    assert f4.validate(args.output)['hold_met']


@pytest.mark.parametrize('timing_passes',[False,True])
def test_native_execution_selects_f4pga_and_gates_programming(tmp_path,monkeypatch,timing_passes):
    spec=importlib.util.spec_from_file_location('native_fpga_runner',ROOT/'scripts/fpga_syn/run.py')
    runner=importlib.util.module_from_spec(spec);spec.loader.exec_module(runner)
    rtl=source_tree(tmp_path); firmware=tmp_path/'fw.bin';firmware.write_bytes(b'firmware')
    args=SimpleNamespace(output=tmp_path/'execution',firmware=firmware,rtl=rtl,core='vex',
                         ram_size=262144,timeout=60,vivado='vivado',board_serial='TEST123',
                         port='test-port',uart_container=None,tool='f4pga')
    calls=[]
    def invoke(cmd,**kwargs):
        calls.append(cmd)
        if cmd[0]=='bash':
            assert kwargs['env']['FPGA_SYN_TOOL']=='f4pga'
            assert kwargs['env']['FPGA_SYN_FIRMWARE_BIN']==str(firmware)
            assert 'FPGA_SYN_INIT_COE' not in kwargs['env']
            completed(args.output/'synthesis',setup=1,hold=0.1 if timing_passes else None)
        if any('run_arty.py' in str(c) for c in cmd):
            assert cmd[cmd.index('--programmer')+1]=='openfpgaloader'
            board=args.output/'board';board.mkdir()
            (board/'execution.json').write_text('{"passed": true}')
            (board/'uart.bin').write_bytes(b'Program finish.\nMLONMCU EXIT: 0\n')
    monkeypatch.setattr(runner.subprocess,'run',invoke)
    assert runner.run(args)==timing_passes
    assert any(any('run_arty.py' in str(c) for c in cmd) for cmd in calls)==timing_passes


def test_clock_aliases_deduplicate_by_bits_and_reject_conflicts(tmp_path):
    native_outputs(tmp_path)
    p=tmp_path/'vex_arty_top.json';design=json.loads(p.read_text())
    design['modules']['vex_arty_top']['netnames']['renamed_core_clk']={'bits':[2]}
    p.write_text(json.dumps(design))
    sdc=tmp_path/'vex_arty_top.sdc'
    sdc.write_text(sdc.read_text()+'create_clock -period 50.000 renamed_core_clk\n')
    f4.deduplicate_sdc(tmp_path)
    assert (tmp_path/'constraints.sdc').read_text().count('create_clock')==2
    sdc.write_text(sdc.read_text().replace('50.000 renamed_core_clk','25.000 renamed_core_clk'))
    with pytest.raises(ValueError,match='Conflicting'):f4.deduplicate_sdc(tmp_path)


def test_standalone_symbiflow_dispatch_rejects_unsupported_core_without_vivado(tmp_path):
    env=dict(os.environ,FPGA_SYN_TOOL='symbiflow',FPGA_SYN_PYTHON=sys.executable)
    result=subprocess.run(['bash',str(ROOT/'scripts/fpga_syn_script.sh'),str(tmp_path/'out'),
                           str(tmp_path),'UNSUPPORTED',f4.PART,'50'],env=env,capture_output=True,text=True)
    assert result.returncode!=0 and 'currently supports' in result.stderr
    assert json.loads((tmp_path/'out/execution.json').read_text())['tool']=='f4pga'


def test_vivado_collection_keeps_total_and_component_overheads(tmp_path):
    for name,luts in [('baseline',100),('default',125)]:
        reports=tmp_path/name/'reports';reports.mkdir(parents=True)
        text='Module,Total LUTs,FFs,RAMB18,RAMB36,DSP Blocks\n(top),'+str(luts)+',50,1,2,3\n'
        if name=='default':text+='ISAX_XIsaac,20,10,0,0,0\nSCAL,5,2,0,0,0\n'
        (reports/'utilization_hier_impl_summary.csv').write_text(text)
    out=tmp_path/'metrics.csv'
    subprocess.run([sys.executable,str(ROOT/'scripts/collect_fpga_syn_metrics.py'),
                    '--baseline-dir',str(tmp_path/'baseline'),'--default-dir',str(tmp_path/'default'),
                    '--output',str(out)],check=True)
    import csv
    rows=list(csv.DictReader(out.open()))
    assert float(rows[1]['luts_total_overhead'])==25
    assert float(rows[1]['luts_isax_overhead'])==20
    assert float(rows[1]['brams_total'])==3


def test_vpr_81_worst_negative_slack_labels(tmp_path):
    native_outputs(tmp_path,setup=-0.25,hold=0)
    log=tmp_path/'route.log'
    log.write_text(log.read_text().replace('setup slack (sWNS)', 'setup Worst Negative Slack (sWNS)').replace('hold slack (hWNS)', 'hold Worst Negative Slack (hWNS)'))
    metrics=f4.parse_results(tmp_path)
    assert not metrics['setup_met'] and metrics['hold_met']


def routed_fixture(tmp_path):
    rtl=source_tree(tmp_path);out=tmp_path/'out';completed(out)
    meta=json.loads((out/'execution.json').read_text())
    meta.update(passed=False,status='failed',completed_steps=f4.STEPS[:4],
                rtl_sha256={str(rtl/'VexRiscv.v'):f4.sha(rtl/'VexRiscv.v')},
                adapter_sha256={str(f4.HERE/'ram.sv'):f4.sha(f4.HERE/'ram.sv')},env_script_sha256=None)
    (out/'execution.json').write_text(json.dumps(meta))
    (out/'route.log').write_text((out/'route.log').read_text()+'VPR succeeded\n')
    (out/'firmware.hex').write_text('00000000\n')
    (out/'rtl').mkdir()
    (out/'rtl/staged.v').write_text('module staged; endmodule\n')
    return SimpleNamespace(output=out,rtl=rtl,core='VEX_5S',part=f4.PART,board='arty_a7_100',
                           clock_ns=50,env_script=None,launcher='',timeout=10)


@pytest.mark.parametrize('bad_fasm',[False,True])
def test_resume_reuses_route_but_rejects_empty_or_pin_only_fasm(tmp_path,monkeypatch,bad_fasm):
    args=routed_fixture(tmp_path);calls=[]
    def invoke(cmd,**kwargs):
        calls.append(cmd)
        if any(str(c).endswith('write_fasm.py') for c in cmd):
            assert 'constraints.sdc' in cmd
            text='IOB_X0Y1.LVCMOS33\n' if bad_fasm else 'CLBLL_L_X1Y1.LOGIC\nBRAM_L_X2Y1.RAM\n'
            (args.output/'vex_arty_top.fasm').write_text(text)
        else:(args.output/'vex_arty_top.bit').write_bytes(b'bitstream')
    monkeypatch.setattr(f4.subprocess,'run',invoke)
    assert f4.resume_routed(args)==(not bad_fasm)
    assert len(calls)==(1 if bad_fasm else 2)
    assert str(calls[0][1]).endswith('write_fasm.py')
    if not bad_fasm: assert calls[1][0]=='symbiflow_write_bitstream'
    if not bad_fasm:
        assert f4.validate(args.output)['luts_total']==2
        assert json.loads((args.output/'execution.json').read_text())['resumed_from_route']


def test_resume_rejects_changed_inputs_before_tools(tmp_path,monkeypatch):
    args=routed_fixture(tmp_path)
    (args.rtl/'VexRiscv.v').write_text('changed input')
    monkeypatch.setattr(f4.subprocess,'run',lambda *a,**kw:pytest.fail('must not run tools'))
    assert not f4.resume_routed(args)
    assert 'Changed routed-build input' in json.loads((args.output/'execution.json').read_text())['error']


def test_uart_protocol_and_serial_fifo(tmp_path):
    if not shutil.which('iverilog'): pytest.skip('Icarus is not installed')
    subprocess.run(['iverilog', '-g2012', '-s', 'tb', '-o', str(tmp_path/'sim'),
                    str(ROOT/'scripts/fpga_syn/f4pga/axi_uart.sv'),
                    str(ROOT/'tests/rtl/f4pga_uart_tb.sv')], check=True)
    result = subprocess.run(['vvp', str(tmp_path/'sim')], capture_output=True, text=True, check=True)
    assert 'PASS UART' in result.stdout


def test_sv2v_constant_selects():
    assert f4.normalize_constant_selects("3'b101[1:0] 8'hf3[6-:3] 2'b00[0]") == "2'h1 3'h7 1'h0"
    assert f4.normalize_constant_selects("CONFIG[31-:32] data[index]") == "CONFIG[31-:32] data[index]"
    with pytest.raises(ValueError): f4.normalize_constant_selects("2'h3[3:0]")


def test_cannot_reuse_vex_as_cva5_baseline(tmp_path):
    completed(tmp_path)
    with pytest.raises(ValueError): f4.validate(tmp_path, core='CVA5')


def test_cva5_staging_and_disabled_cache_contract(tmp_path):
    rtl=tmp_path/'input';rtl.mkdir()
    (rtl/'files.txt').write_text('CVA5_top.v\ncva5_config.sv\nscaiev_unit.sv\n')
    (rtl/'CVA5_top.v').write_text('module cva5_top;\n'+''.join(
        f'wire [29:0] {kind}_bram_addr;\nblk_mem_gen_0 {kind}(.addra({kind}_bram_addr));\n'
        for kind in ['instruction','data'])+'endmodule\n')
    (rtl/'cva5_config.sv').write_text('INCLUDE_ICACHE : 0, INCLUDE_DCACHE : 0, INCLUDE_IBUS : 0,')
    (rtl/'scaiev_unit.sv').write_text('assign ls_inputs_scaiev.fn3 = LS_W_fn3; //Full word')
    original=(rtl/'CVA5_top.v').read_bytes()
    out=tmp_path/'out';out.mkdir()
    sources, hashes=f4.prepare(rtl,out,core='CVA5')
    assert 'rtl/axi_uart.sv' in sources and 'rtl/cva5_arty_top.sv' in sources
    words=(out/'firmware.hex').read_text().splitlines(keepends=True)
    for bank in range(2):
        assert (out/f'firmware-{bank}.hex').read_text()==''.join(words[bank*32768:(bank+1)*32768])
    assert '.addra(data_bram_addr[17:2])' in (out/'rtl/CVA5_top.v').read_text()
    assert 'execute_Instr[14:12]' in (out/'rtl/scaiev_unit.sv').read_text()
    assert (rtl/'CVA5_top.v').read_bytes()==original
    assert 'PLLE2_ADV' in (out/'rtl/cva5_arty_top.sv').read_text()
    (rtl/'cva5_config.sv').write_text('INCLUDE_ICACHE : 1, INCLUDE_DCACHE : 0, INCLUDE_IBUS : 0,')
    bad=tmp_path/'bad';bad.mkdir()
    with pytest.raises(ValueError,match='INCLUDE_ICACHE'): f4.prepare(rtl,bad,core='CVA5')


def test_cva5_ram_write_first_byte_lanes_and_boundary(tmp_path):
    if not shutil.which('iverilog'): pytest.skip('Icarus is not installed')
    (tmp_path/'firmware-0.hex').write_text('12345678\n'+'00000000\n'*32767)
    (tmp_path/'firmware-1.hex').write_text('00000000\n'*32768)
    (tmp_path/'test.sv').write_text('''module tb;
reg clk=0;always #5 clk=~clk;
reg en=1;reg[3:0]we=0;reg[15:0]addr=0;reg[31:0]din=0;wire[31:0]dout;
blk_mem_gen_0 ram(clk,en,we,addr,din,dout);
initial begin
 #6;if(dout!==32'h12345678)$fatal(1,"firmware");
 we=4'b0101;din=32'hdeadbeef;
 #10;if(dout!==32'h12ad56ef)$fatal(1,"write first bytes");
 en=0;addr=16'hffff;#10;if(dout!==32'h12ad56ef)$fatal(1,"disabled");
 en=1;we=15;din=32'h87654321;#10;if(dout!==din)$fatal(1,"last address write");
 addr=0;we=0;#10;if(dout!==32'h12ad56ef)$fatal(1,"address alias");
 addr=16'hffff;#10;if(dout!==32'h87654321)$fatal(1,"last address read");
 $display("PASS");$finish;end
endmodule''')
    subprocess.run(['iverilog','-g2012','-s','tb','-o','sim',str(ROOT/'scripts/fpga_syn/f4pga/cva5_ram.sv'),'test.sv'],cwd=tmp_path,check=True)
    result=subprocess.run(['vvp','sim'],cwd=tmp_path,capture_output=True,text=True,check=True)
    assert 'PASS' in result.stdout


def test_cva5_empty_program_rejected_before_tools(tmp_path):
    args=SimpleNamespace(output=tmp_path/'out',rtl=tmp_path,core='CVA5',board='arty_a7_100',
                         part=f4.PART,clock_ns=50,timeout=10,firmware=None,coe=None)
    assert not f4.run(args)
    assert 'empty instruction ROM' in json.loads((args.output/'execution.json').read_text())['error']


def test_intel_hints_removed_and_xilinx_hints_retained():
    source='(* ramstyle = "MLAB, no_rw_check", ram_style = "distributed" *) reg a;\n'
    source+='(* ram_style = "block", ramstyle = "no_rw_check" *) reg b;\n'
    source+='(* ramstyle = "MLAB, no_rw_check" *) reg c;'
    result=f4.strip_intel_ramstyle(source)
    assert 'ramstyle' not in result
    assert 'ram_style = "distributed"' in result and 'ram_style = "block"' in result


def test_ram_initializers_preserve_memories():
    result=f4.preserve_ram_arrays('branch_predictor_ram.sv', "initial branch_ram = '{default: 0};")
    assert 'branch_ram[isaac_init]' in result and 'isaac_init < C_DEPTH' in result
    result=f4.preserve_ram_arrays('mul_unit.sv', "valid <= '{default: 0};")
    assert "valid[0] <= 1'b0" in result and "valid[1] <= 1'b0" in result
    with pytest.raises(ValueError): f4.preserve_ram_arrays('branch_predictor_ram.sv', 'different layout')


def test_ascending_array_export_regression(tmp_path):
    if not shutil.which('yosys') or not shutil.which('iverilog'):
        pytest.skip('Needs Yosys and Icarus for the exporter regression')
    (tmp_path/'pipeline.v').write_text('''module pipeline(input clk,rst,request,output done);
reg [0:1] valid;
always @(posedge clk) if(rst) valid<=2'b0;
else begin valid[0]<=request;valid[1]<=valid[0];end
assign done=valid[1];endmodule''')
    subprocess.run(['yosys','-Q','-p',
                    'read_verilog pipeline.v; proc; opt; splitnets -ports; write_verilog lowered.v'],
                   cwd=tmp_path,check=True,capture_output=True)
    (tmp_path/'tb.v').write_text('''module tb;
reg clk=0;always #5 clk=~clk;reg rst=1,request=0;wire done;
pipeline dut(clk,rst,request,done);
initial begin
 #6;if(done!==0)$fatal(1,"reset");rst=0;request=1;
 #10;if(done!==0)$fatal(1,"early completion");request=0;
 #10;if(done!==1)$fatal(1,"missing completion");
 #10;if(done!==0)$fatal(1,"completion did not clear");
 $display("PASS");$finish;end
endmodule''')
    subprocess.run(['iverilog','-g2012','-s','tb','-o','sim','lowered.v','tb.v'],cwd=tmp_path,check=True)
    result=subprocess.run(['vvp','sim'],cwd=tmp_path,capture_output=True,text=True,check=True)
    assert 'PASS' in result.stdout


def test_cva5_mapped_memory_capacity_guard(tmp_path):
    native_outputs(tmp_path)
    for p in list(tmp_path.glob('vex_arty_top.*')):
        q=p.with_name(p.name.replace('vex_arty_top','cva5_arty_top'))
        q.write_bytes(p.read_bytes().replace(b'vex_arty_top',b'cva5_arty_top'))
        p.unlink()
    (tmp_path/'execution.json').write_text(json.dumps({'core':'CVA5'}))
    with pytest.raises(ValueError,match='256 KiB'): f4.parse_results(tmp_path)
    p=tmp_path/'cva5_arty_top.json';design=json.loads(p.read_text())
    cells=design['modules']['cva5_arty_top']['cells']
    cells.update({f'cpu.data_bram.memory.{i}':{'type':'RAMB36E1_PRIM'} for i in range(64)})
    p.write_text(json.dumps(design))
    assert f4.parse_results(tmp_path)['brams_18k_equivalent']==130
    del cells['cpu.data_bram.memory.63'];p.write_text(json.dumps(design))
    with pytest.raises(ValueError,match='256 KiB'): f4.parse_results(tmp_path)
