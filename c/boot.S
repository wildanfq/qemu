    .section .text.init
    .globl _start
    .type _start, @function

_start:
    # Stack pointer -> top of RAM
    la      sp, _stack_top

    # Enter C kernel
    call    kmain

.Lhalt:
    j       .Lhalt

    .size _start, . - _start