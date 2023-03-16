TARGET:=riscv64gc-unknown-none-elf
DEV_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PROJECT_DIR:=$(shell dirname $(DEV_DIR))
SOURCE_DIR:=$(realpath $(PROJECT_DIR)/src)
TARGET_DIR:=$(realpath $(PROJECT_DIR)/target/$(TARGET))

run: rusty compile link virtualize

dev: rusty compile link debug-virt

rusty:
	cargo build

compile:
	riscv64-unknown-elf-as $(SOURCE_DIR)/hello_world.s -o $(TARGET_DIR)/debug/boot.o

link:
	riscv64-unknown-elf-ld -T $(SOURCE_DIR)/kernel.lds $(TARGET_DIR)/debug/boot.o $(TARGET_DIR)/debug/libbare_metal.a -o $(TARGET_DIR)/debug/kernel.elf

virtualize:
	qemu-system-riscv64 -machine virt -cpu rv64 -smp 4 -m 8192M -nographic -bios none -kernel $(TARGET_DIR)/debug/kernel.elf

debug-virt:
	qemu-system-riscv64 -machine virt -cpu rv64 -smp 4 -m 8192M -nographic -bios none -kernel $(TARGET_DIR)/debug/kernel.elf -S -s

docker-build:
	docker build . -t NAME_OF_DOCKER_IMAGE

docker-run:
	docker run -it --rm -v $(PROJECT_DIR):/bare_metal NAME_OF_DOCKER_IMAGE

debug:
	gdb-multiarch $(TARGET_DIR)/debug/kernel.elf --command=$(DEV_DIR)/gdb.conf
