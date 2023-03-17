.align 2

# Define UART constants for qemu-virt
.equ VIRT_UART_BASE, 0x10000000
.equ VIRT_UART_REG_TXFIFO, 0x0

.section .text

.globl _start
.extern _rust_entry

/*
*   _start is the entrypoint for all harts.
*   args: none
*   returns: none
*/
_start:
    # Halt harts not equal to ID: 0
    csrr    t0, mhartid             
    bnez    t0, halt

    # Initialize stack
    la      sp, _stack_top

    # Call write
    # Give it an argument
    la      a0, msg
    # Call the puts function
    jal     write

    call    _rust_entry

/*
*   halt pauses execution of the current hart.
*   args: none
*   returns: none
*/
halt:
    # Wait for any inturrupt
    wfi

/*
*   write attempts to print the given ascii values to the console through UART.
*   args: a0 - pointer to the ascii string to print
*   returns: none
*/
write:
    li      t0, VIRT_UART_BASE

.write_loop:
    # Grab the function argument
    lbu     t1, (a0)
    beqz    t1, .write_leave

.write_wait:
    lw      t2, VIRT_UART_REG_TXFIFO(t0)
    # Try again if UART byte isn't ready
    bltz    t2, .write_wait
    # Store the byte into UART
    sw      t1, VIRT_UART_REG_TXFIFO(t0)
    # Iterate to the next argument byte
    add     a0, a0, 1
    j       .write_loop

.write_leave:
    ret

.section .rodata

msg:
    .string "hello there\n"
