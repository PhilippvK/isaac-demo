OUTPUT_ARCH(riscv)
ENTRY(_start)
MEMORY { RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 256K }
SECTIONS {
 . = ORIGIN(RAM);
 .text : { KEEP(*(.text.start)) *(.text .text.*) } > RAM
 .rodata : { *(.rodata .rodata.*) } > RAM
 .data : { *(.data .data.*) *(.sdata .sdata.*) } > RAM
 . = ALIGN(16);
 PROVIDE(__global_pointer$ = . + 0x800);
 .bss (NOLOAD) : { __bss_start = .; *(.bss .bss.* .sbss .sbss.*) *(COMMON) . = ALIGN(4); __bss_end = .; } > RAM
 __stack_top = ORIGIN(RAM) + LENGTH(RAM) - 16;
 ASSERT(__bss_end + 8192 < __stack_top, "Firmware leaves less than 8 KiB stack")
}
