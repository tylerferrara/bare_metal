.align 2

# Define UART constants for qemu-virt
.equ VIRT_UART_BASE, 0x10000000
.equ VIRT_UART_REG_TXFIFO, 0x0

.section .text

.extern _rust_entry

.globl _start

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

    jal     ra, _rust_entry
    ret

/*
*   halt pauses execution of the current hart.
*   args: none
*   returns: none
*/
halt:
    # Wait for any inturrupt
    wfi

.globl print_stuff
print_stuff:
    la      a0, msg
    # Call the puts function
    j     write

/*
*   write attempts to print the given ascii values to the console through UART.
*   args: a0 - pointer to the ascii string to print
*   returns: none
*/
.globl write
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
    jr      ra

.section .rodata

msg:
    .string "hello there\n"
