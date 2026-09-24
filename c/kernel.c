#include <stdint.h>

#define UART0_BASE 0x10000000UL
#define UART_THR   0

static volatile uint8_t *const uart0 =
    (volatile uint8_t *)UART0_BASE;

static const char hello[] = "Hello, World!\n";

static void uart_putc(char c)
{
    uart0[UART_THR] = (uint8_t)c;
}

static void uart_puts(const char *s)
{
    while (*s != '\0') {
        uart_putc(*s);
        s++;
    }
}

void kmain(void)
{
    uart_puts(hello);

    for (;;) {
        /* halt */
    }
}