compile:
	riscv64-unknown-elf-as hello_world.s -o virt/boot.o

link:
	riscv64-unknown-elf-ld -T kernel.lds virt/boot.o -o virt/kernel.elf

virtualize:
	qemu-system-riscv64 -machine virt -cpu rv64 -smp 4 -m 8192M -nographic -bios none -kernel virt/kernel.elf

run: compile link virtualize
