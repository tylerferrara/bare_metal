DOCKER_IMAGE_TAG:=bare_metal
TARGET:=riscv64gc-unknown-none-elf
DEV_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PROJECT_DIR:=$(shell dirname $(DEV_DIR))
SOURCE_DIR:=$(realpath $(PROJECT_DIR)/src)
TARGET_DIR:=$(realpath $(PROJECT_DIR)/target/$(TARGET))

################################################################################################################################################################
#
#								                             ##        .            
#		██████  ███████ ██    ██ 	    			   ## ## ##       ==            
#		██   ██ ██      ██    ██ 					## ## ## ##      ===            
#		██   ██ █████   ██    ██ 			   /""""""""""""""""\___/ ===        
#		██   ██ ██       ██  ██			  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~   
#		██████  ███████   ████			       \______ o          __/            
#												 \    \        __/             
#												  \____\______/                
#
# The following targets are used to build the project on the host machine.


shell:
	@echo "🐚 Running shell attached container..."
	docker run -it -u architect -w /bare_metal -v $(PROJECT_DIR):/bare_metal $(DOCKER_IMAGE_TAG)

dock: docker-build
	@echo "🛥️ Running detached container..."
	docker run -t -d -v $(PROJECT_DIR):/bare_metal $(DOCKER_IMAGE_TAG)

kill:
	@echo "🛑 Killing 'possibly' running containers..."
	docker kill $(shell docker ps -f "ancestor=$(DOCKER_IMAGE_TAG)" -f "status=running" -q) > /dev/null 2>&1 || true

docker-build: docker-rm-tag
	@echo "🏗️ Building container(s)..."
	docker build -t $(DOCKER_IMAGE_TAG) $(DEV_DIR)

docker-rm-tag:
	@echo "🗑️ Removing container tag..."
	docker rmi $(DOCKER_IMAGE_TAG) > /dev/null 2>&1 || true


################################################################################################################################################################
#
#		 ███╗   ███╗███████╗████████╗ █████╗ ██╗     		
#		 ████╗ ████║██╔════╝╚══██╔══╝██╔══██╗██║     
#		 ██╔████╔██║█████╗     ██║   ███████║██║     
#		 ██║╚██╔╝██║██╔══╝     ██║   ██╔══██║██║     
#		 ██║ ╚═╝ ██║███████╗   ██║   ██║  ██║███████╗
#		 ╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
#  .______________________________________________________|_._._._._._._._._._.
#   \_____________________________________________________|_#_#_#_#_#_#_#_#_#_|
#    \____________________________________________________|_#_#_#_#_#_#_#_#_#_|
#
# The following targets are defined to run within a docker container. This is useful if you don't want to install the toolchain on your host machine.

metal-setup:
	rustup default nightly
	rustup target add $(TARGET)

metal-run: metal-build metal-compile metal-link metal-virtualize

metal-dev: metal-build metal-compile metal-link metal-debug-virt

metal-build: metal-compile
	cargo build

metal-compile:
	riscv64-unknown-elf-as $(SOURCE_DIR)/hello_world.s -o $(TARGET_DIR)/debug/boot.o

metal-link:
	riscv64-unknown-elf-ld -T $(SOURCE_DIR)/kernel.lds $(TARGET_DIR)/debug/boot.o $(TARGET_DIR)/debug/libbare_metal.a -o $(TARGET_DIR)/debug/kernel.elf

metal-virtualize:
	qemu-system-riscv64 -machine virt -cpu rv64 -smp 4 -m 8192M -nographic -bios none -kernel $(TARGET_DIR)/debug/kernel.elf

metal-debug-virt:
	qemu-system-riscv64 -machine virt -cpu rv64 -smp 4 -m 8192M -nographic -bios none -kernel $(TARGET_DIR)/debug/kernel.elf -S -s

metal-debug:
	gdb-multiarch $(TARGET_DIR)/debug/kernel.elf --command=$(DEV_DIR)/gdb.conf

