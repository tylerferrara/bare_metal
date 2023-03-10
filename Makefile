
rusty:
	cargo build

compile:
	riscv64-unknown-elf-as hello_world.s -o virt/boot.o

link:
	riscv64-unknown-elf-ld -T kernel.lds virt/boot.o target/riscv64gc-unknown-none-elf/debug/libbare_metal.a -o virt/kernel.elf

virt:
	qemu-system-riscv64 -machine virt -cpu rv64 -smp 4 -m 8192M -nographic -bios none -kernel virt/kernel.elf

debug-virt:
	qemu-system-riscv64 -machine virt -cpu rv64 -smp 4 -m 8192M -nographic -bios none -kernel virt/kernel.elf -S -s

run: rusty compile link virt

dev: rusty compile link debug-virt

debug:
	gdb-multiarch ./virt/kernel.elf --command=./gdb.conf