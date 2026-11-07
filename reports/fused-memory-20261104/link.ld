ENTRY(_start)
SECTIONS { . = 0x01000000; .text : { *(.text*) } .rodata : { *(.rodata*) } . = 0x01800000; .data : { *(.data*) *(.sdata*) } .bss : { *(.bss*) *(.sbss*) *(COMMON) } }
