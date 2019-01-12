#include <avr/io.h>
#include "kernel.h"

#define F_CPU 16000000
#include <util/delay.h>

void f1()
{
	DDRB |= 0x01;

	while (1) {
		PORTB ^= 0x01;
		_delay_ms(500);
	}
}

void f2()
{
	DDRB |= 0x08;

	while (1) {
		PORTB ^= 0x08;
		_delay_ms(500);
	}
}

int main(void)
{
    // TODO: implement a kernel :)
	register_process(f1);
	register_process(f2);
	kernel_start();
	
    while (1);
}

