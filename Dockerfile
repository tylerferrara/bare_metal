FROM ubuntu:kinetic

RUN apt-get update && apt-get install -y \
    git \
    gdb-multiarch \
    qemu-system-riscv64 \
    curl \
    zsh;

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh;


