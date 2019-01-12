
#ifndef KERNEL_H_
#define KERNEL_H_

#include <stdint.h>
#include <stddef.h>

typedef struct __attribute__((packed)) {
	char registers[32];
	uint16_t sp;
	uint16_t pc;
	void(*fp)(void);
} ctxt_t;

void register_process(void (*)(void));
void kernel_start();

#endif
