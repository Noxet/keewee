#include "kernel.h"

#include <avr/interrupt.h>

extern void save_process_state();

static ctxt_t process_list[10];
char *proc_registers;
char *proc_sp;
char *proc_pc;

void register_process(void (*fp)(void))
{
	static int p_count = 0;
	
	// create new process, register function pointer
	ctxt_t proc = {
		.registers = {0},
		.sp = 0,
		.pc = 0,
		.fp = fp
	};
	
	// add process to process list
	process_list[p_count++] = proc;
}

void kernel_start()
{
	// set up LED for debug
	DDRB |= 0x80;
	
	// enable interrupts
	sei();
	
	// set up timer
	TIMSK1 |= _BV(TOIE1);
	
	proc_registers = process_list[0].registers;
	TCCR1B |= _BV(CS12);	// start timer
	process_list[0].fp();	// run first process
}

/*
ISR(TIMER1_OVF_vect)
{
	PORTB ^= 0x80;
	//save_process_state();
}
*/
