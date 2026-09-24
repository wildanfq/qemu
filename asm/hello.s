    .equ UART0_BASE, 0x10000000
    .equ UART_LSR,   5
    .equ UART_THR,   0
    .equ UART_THRE,  0x20

    .section .text.init
    .globl _start
    .type _start, @function

_start:
    la      sp, _stack_top

    li      t0, UART0_BASE

    la      t1, hello_string

.Lloop:
    lbu     t2, 0(t1)

    beqz    t2, .Ldone

.Lwait_uart:
    lbu     t3, UART_LSR(t0)
    andi    t3, t3, UART_THRE
    beqz    t3, .Lwait_uart

    sb      t2, UART_THR(t0)

    addi    t1, t1, 1

    j       .Lloop

.Ldone:
    j       .Ldone

    .size _start, . - _start

    .section .rodata
    .align  2

hello_string:
    .asciz "Hello, World!\n"