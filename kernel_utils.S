#include <avr/io.h>

.extern proc_registers

;.org 0x001E
;rjmp TIMER1_OVF_vect

.global TIMER1_OVF_vect
TIMER1_OVF_vect:
	ldi r18, 0x02
	out PORTB-0x20, r18
	reti

.global save_process_state
save_process_state:
	push r30
	push r31	; save Z register
	;push r28
	;push r29	; save Y register
	ldi ZL, lo8(proc_registers)
	ldi ZH, hi8(proc_registers)	; load address of proc_registers
	;ldi YL, 0x00
	;ldi YH, 0x00	; load address of register r0

	; ugly as fuck, but fast :)
	st Z+, r0
	st Z+, r1
	st Z+, r2
	st Z+, r3
	st Z+, r4
	st Z+, r5
	st Z+, r6
	st Z+, r7
	st Z+, r8
	st Z+, r9
	st Z+, r10
	st Z+, r11
	st Z+, r12
	st Z+, r13
	st Z+, r14
	st Z+, r15
	st Z+, r16
	st Z+, r17
	st Z+, r18
	st Z+, r19
	st Z+, r20
	st Z+, r21
	st Z+, r22
	st Z+, r23
	st Z+, r24
	st Z+, r25
	st Z+, r26
	st Z+, r27
	st Z+, r28
	st Z+, r29
	movw Y, Z	; copy address to Y
	pop 31
	pop 30		; restore Z
	st Y+, r30
	st Y, r31	; save Z