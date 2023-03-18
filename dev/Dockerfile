################################################################################################################################################################
# TARGET: core
FROM ubuntu:kinetic AS core

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

################################################################################################################################################################
# TARGET: env
FROM core AS env

RUN apt-get update && apt-get install -y \
    git \
    sudo \
    zsh \
    python3-pip;

# Create User
RUN useradd -ms /usr/bin/zsh architect && \
    echo "architect ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers;

RUN mkdir /bare_metal && \
    chown architect:architect /bare_metal;

# Install Z-Shell Addons
RUN mkdir -p /home/architect/.zsh
RUN git clone https://github.com/z-shell/F-Sy-H /home/architect/.zsh/F-Sy-H
RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/architect/.zsh/zsh-autosuggestions
RUN curl --proto '=https' --tlsv1.2 -sSf https://starship.rs/install.sh | sh -s -- -y

# Setup User
USER architect
COPY .zshrc /home/architect/.zshrc

# Install Rust (for the user)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y;
RUN /home/architect/.cargo/bin/rustup default nightly && \
    /home/architect/.cargo/bin/rustup target add riscv64gc-unknown-none-elf;

# GDB Dashboard: https://github.com/cyrus-and/gdb-dashboard
COPY .gdbinit /home/architect/.gdbinit

CMD ["/usr/bin/zsh"]