# RISC-V C (Compression Extension)
.align 2

# Define UART constants for qemu-virt
.equ VIRT_UART_BASE, 0x10000000
.equ VIRT_UART_REG_TXFIFO, 0x0

# EXECUTABLE CODE
.section .text

.globl _start
_start:
    # Halt harts not equal to ID: 0
    csrr    t0, mhartid             
    bnez    t0, halt

    # Initialize stack
    la      sp, _stack_top

    la a0, msg
    jal ra, print
    jal ra, write

halt:
    # Wait for any inturrupt
    wfi

print:
    li t1, VIRT_UART_BASE
    j .print_loop

.print_loop:
    lbu t0, 0(a0)
    beqz t0, .print_done
    sw t0, VIRT_UART_REG_TXFIFO(t1)
    addi a0, a0, 1
    j .print_loop

.print_done:
    jr ra

write:
    lbu t0, 0(a0)
    ret


# READ ONLY DATA
.section .rodata

msg:
    .string "h"
