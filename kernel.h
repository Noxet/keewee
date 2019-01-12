
#ifndef KERNEL_H_
#define KERNEL_H_

#include <stdint.h>
#include <stddef.h>

typedef struct {
	char registers[32];
	uint16_t sp;
	uint16_t pc;
	void(*fp)(void);
} ctxt_t __attribute__((packed));

void register_process(void (*)(void));
void kernel_start();

#endif