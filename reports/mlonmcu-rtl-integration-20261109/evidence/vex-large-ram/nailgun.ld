OUTPUT_ARCH(riscv)
ENTRY(_start)
MEMORY { RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 524288 }
SECTIONS {
 . = ORIGIN(RAM);
 .text : { KEEP(*(.text.start)) *(.text .text.*) } > RAM
 .rodata : { *(.rodata .rodata.*) } > RAM
 .preinit_array : { PROVIDE_HIDDEN(__preinit_array_start = .); KEEP(*(.preinit_array)) PROVIDE_HIDDEN(__preinit_array_end = .); } > RAM
 .init_array : { PROVIDE_HIDDEN(__init_array_start = .); KEEP(*(SORT_BY_INIT_PRIORITY(.init_array.*))) KEEP(*(.init_array)) PROVIDE_HIDDEN(__init_array_end = .); } > RAM
 .fini_array : { PROVIDE_HIDDEN(__fini_array_start = .); KEEP(*(SORT_BY_INIT_PRIORITY(.fini_array.*))) KEEP(*(.fini_array)) PROVIDE_HIDDEN(__fini_array_end = .); } > RAM
 .data : { *(.data .data.*) *(.sdata .sdata.*) } > RAM
 . = ALIGN(16);
 PROVIDE(__global_pointer$ = . + 0x800);
 .bss (NOLOAD) : { __bss_start = .; *(.bss .bss.* .sbss .sbss.*) *(COMMON) . = ALIGN(4); __bss_end = .; } > RAM
 __stack_top = ORIGIN(RAM) + LENGTH(RAM) - 16;
 ASSERT(__bss_end + 16384 + 4096 < __stack_top, "Insufficient Nailgun RAM for static data, heap and stack")
}
