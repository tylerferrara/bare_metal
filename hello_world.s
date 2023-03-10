.align 2

.equ VIRT_UART_BASE, 0x10000000
.equ VIRT_UART_REG_TXFIFO, 0x0


.section .text
.globl _start

.extern _rust_entry

_start:
    # Halt harts not equal to ID: 0
    csrr    t0, mhartid             
    bnez    t0, halt

    # Initialize stack
    la      sp, _stack_top

    # Call puts
    # Give it an argument
    la      a0, msg
    # Call the puts function
    jal     puts

    call    _rust_entry

# Halt hart
halt:
    # Wait for any inturrupt
    wfi

puts:
    li      t0, VIRT_UART_BASE

.puts_loop:
    # Grab the function argument
    lbu     t1, (a0)
    beqz    t1, .puts_leave

.puts_wait:
    lw      t2, VIRT_UART_REG_TXFIFO(t0)
    # Try again if UART byte isn't ready
    bltz    t2, .puts_wait
    # Store the byte into UART
    sw      t1, VIRT_UART_REG_TXFIFO(t0)
    # Iterate to the next argument byte
    add     a0, a0, 1
    j       .puts_loop

.puts_leave:
    ret


.section .rodata

msg:
    .string "hello there\n"
