FROM ubuntu:kinetic

RUN apt-get update && apt-get install -y \
    git \
    gdb-multiarch \
    qemu-system-riscv64 \
    curl \
    zsh \
    autoconf \
    automake \
    autotools-dev \
    python3 \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    build-essential \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev \
    ninja-build;

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y;

# Install RISC-V toolchain
RUN mkdir /opt/riscv && \
    git clone https://github.com/riscv/riscv-gnu-toolchain && \
    cd riscv-gnu-toolchain && \
    ./configure --prefix=/opt/riscv && \
    make -j8 && \
    make install;
