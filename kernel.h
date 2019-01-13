
#ifndef KERNEL_H_
#define KERNEL_H_

#define STACK_TOP	0x4000
#define STACK_SPACE	0x500

#include <stdint.h>
#include <stddef.h>

typedef enum {READY, RUNNING} STATE;

typedef struct __attribute__((packed)) {
	STATE state;
	char registers[32];
	uint16_t sp;
	uint16_t pc;
	uint8_t sreg;
	void(*fp)(void);
} ctxt_t;

void register_process(void (*)(void));
void kernel_start();

#endif
