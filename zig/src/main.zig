const UART0: *volatile u8 = @ptrFromInt(0x1000_0000);

const hello = "Hello, World!\n";

export fn _start() linksection(".text.init") callconv(.naked) noreturn {
    asm volatile (
        \\ la  sp, _sstack
        \\ call kmain
        \\ j   .
    );
}

export fn kmain() callconv(.c) noreturn {
    for (hello) |b| {
        UART0.* = b;
    }

    while (true) {}
}
