
gdb_port ?= 3333
build_dir ?= build
src_dir ?= gift
exec ?= baseline64
linker ?= linker_script.ld

debug_flags ?= -ex "b END" -ex "j main" -ex "i r s10"


ASFlags = -march=rv32imac -mabi=ilp32 -g
LDFlags = -T $(linker) 

compile:
	riscv64-unknown-elf-as $(ASFlags) $(src_dir)/$(exec).riscv -o $(exec).o
	riscv64-unknown-elf-ld $(LDFlags) $(exec).o -o $(exec).elf
	mkdir -p build
	mv $(exec).elf $(exec).o $(build_dir)

toHex:
	riscv64-unknown-elf-objcopy -O ihex $(build_dir)/$(exec).elf  $(build_dir)/$(exec).hex

build: compile toHex

upload:
	echo "loadfile $(build_dir)/$(exec).hex\nexit" | JLinkExe -device FE310 -if JTAG -speed 4000 -jtagconf -1,-1 -autoconnect 1

openGDB:
	JLinkGDBServer -device RISC-V -port $(gdb_port)

debug:
	riscv64-unknown-elf-gdb -ex "target extended-remote localhost:$(gdb_port)" $(debug_flags) $(build_dir)/$(exec).elf

clean:
	rm -r build
