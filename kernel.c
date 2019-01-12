#include "kernel.h"

#include <avr/interrupt.h>

extern void restore_process_state();
void switch_context();

static ctxt_t process_list[10];
static int p_count = 0;
char *proc_registers;
uint16_t *proc_sp;
uint16_t *proc_pc;
uint8_t *proc_sreg;

void switch_context()
{
	static uint8_t process_nbr = 0;
	
	PORTB ^= 0x80;
	
	// get the next process struct
	process_nbr = (process_nbr + 1) %  p_count;
	proc_registers = process_list[process_nbr].registers;
	proc_pc = &process_list[process_nbr].pc;
	proc_sp = &process_list[process_nbr].sp;
	proc_sreg = &process_list[process_nbr].sreg;
	
	if (process_list[process_nbr].state == 0) {
		// enable interrupts (we are inside an interrupt that runs cli)
		// call function, never to return again
		process_list[process_nbr].state = 1;
		sei();
		process_list[process_nbr].fp();
	} else {
		// restore all previous saved values
		// NOTE: calling convention NOT complied with in asm
		restore_process_state();
	}
}

void register_process(void (*fp)(void))
{
	// create new process, register function pointer
	ctxt_t proc = {
		.state = 0,
		.registers = {0},
		.sp = STACK_TOP - p_count * STACK_SPACE,
		.pc = 0,
		.sreg = 0,
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
	//TIMSK1 |= _BV(TOIE1);
	
	// debug, use button to trig interrupt
	PCICR |= _BV(PCIE0);
	PCMSK0 |= _BV(PCINT2);
	
	
	proc_registers = process_list[0].registers;
	proc_pc = &process_list[0].pc;
	proc_sp = &process_list[0].sp;
	proc_sreg = &process_list[0].sreg;
	process_list[0].state = 1;
	//TCCR1B |= _BV(CS10);	// prescaling of 1, 4ms process time, also start timer
	process_list[0].fp();	// run first process
}