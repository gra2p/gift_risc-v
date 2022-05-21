OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")
ENTRY(main)
MEMORY
{	
	itim (airwx) : ORIGIN = 0x08000000, LENGTH = 0x2000
    ram (arw!xi) : ORIGIN = 0x80000000, LENGTH = 0x4000
    rom (irx!wa) : ORIGIN = 0x20010000, LENGTH = 0x6a120
}


SECTIONS
{	
    .text : { *(.text*) } > rom
	.itim : {*(.itim*)} >itim AT> itim
    .rodata : ALIGN(4) { *(.rodata*) } > rom
	.data : { *(.data*) } > ram AT> ram
    .bss : { *(.bss*) } > ram 
}