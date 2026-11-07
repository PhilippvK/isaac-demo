# Replace only local memory INIT bits in an existing routed Arty checkpoint.
# A fresh instance of the identical RAM IP provides its byte/bank mapping.
set_param general.maxThreads 4
set base [file normalize [lindex $argv 0]]
set coe [file normalize [lindex $argv 1]]
if {![file isfile $base] || ![file isfile $coe]} {error "Usage: update_init.tcl ROUTED_DCP COE (run in a new output directory)"}
create_project -force -part xc7a100tcsg324-1 firmware_memory ./memory_project
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name blk_mem_gen_0
set_property -dict [list CONFIG.Memory_Type Single_Port_RAM CONFIG.Write_Width_A 32 \
 CONFIG.Write_Depth_A 65536 CONFIG.Use_Byte_Write_Enable true CONFIG.Byte_Size 8 \
 CONFIG.Register_PortA_Output_of_Memory_Primitives false \
 CONFIG.Register_PortA_Output_of_Memory_Core false CONFIG.Operating_Mode_A WRITE_FIRST \
 CONFIG.Load_Init_File true CONFIG.Coe_File $coe] [get_ips blk_mem_gen_0]
generate_target all [get_ips blk_mem_gen_0]
synth_ip [get_ips blk_mem_gen_0]
set ip_dcp [glob memory_project/firmware_memory.gen/sources_1/ip/blk_mem_gen_0/*.dcp]
if {[llength $ip_dcp] != 1} {error "Expected one RAM IP checkpoint: $ip_dcp"}
close_project
open_checkpoint [lindex $ip_dcp 0]
set init_data [dict create]
set configs [dict create]
set config_names {READ_WIDTH_A READ_WIDTH_B WRITE_WIDTH_A WRITE_WIDTH_B DOA_REG DOB_REG WRITE_MODE_A WRITE_MODE_B}
foreach cell [get_cells -hierarchical -filter {REF_NAME == RAMB36E1}] {
    set values [dict create]
    foreach property [list_property $cell] {
        if {[regexp {^INITP?_[0-9A-F][0-9A-F]$} $property]} {
            dict set values $property [get_property $property $cell]
        }
    }
    if {[dict size $values] != 144} {error "Expected 128 data + 16 parity INITs for $cell"}
    # Cell handles become null when their design closes; retain plain names.
    set name [get_property NAME $cell]
    dict set init_data $name $values
    foreach property $config_names {dict set configs $name $property [get_property $property $cell]}
}
if {[dict size $init_data] != 64} {error "Expected 64 RAMB36s per 256 KiB local memory"}
close_design
open_checkpoint $base
set destinations [dict create]
foreach cell [get_cells -hierarchical -filter {REF_NAME == RAMB36E1}] {dict set destinations $cell $cell}
set patched 0
foreach prefix {cpu/instruction_bram cpu/data_bram} {
    dict for {name values} $init_data {
        set path "$prefix/$name"
        if {![dict exists $destinations $path]} {error "RAM hierarchy does not match: $path"}
        set cell [dict get $destinations $path]
        foreach property $config_names {
            if {[get_property $property $cell] ne [dict get $configs $name $property]} {
                error "RAM configuration differs for $path/$property"
            }
        }
        dict for {property value} $values {set_property $property $value $cell}
        incr patched
    }
}
if {$patched != 128} {error "Expected to patch both complete local memory banks"}
puts "ISAAC_PATCHED_MEMORY_PRIMITIVES=$patched"
write_checkpoint -force initialized.dcp
report_drc -file drc.rpt
write_bitstream -force firmware.bit
