#include <avr/io.h>

.extern proc_registers	;
.extern proc_pc			;
.extern proc_sp			; C variables

.extern switch_context	; C function

#ifdef DEBUG
.global PCINT0_vect
#else
.global TIMER1_OVF_vect
#endif
.global restore_process_state

#ifdef DEBUG
PCINT0_vect:
#else
TIMER1_OVF_vect:
#endif
	; save all registers
	push ZL
	push ZH
	push YL
	push YH
	ldi ZL, lo8(proc_registers)
	ldi ZH, hi8(proc_registers)	; load address of the pointer to proc_registers vector
	ld YL, Z+
	ld YH, Z
	movw Z, Y
	pop YH
	pop YL

	; save registers
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

	pop ZH
	pop ZL		; restore Z reg
	st Y+, r30
	st Y, r31	; save Z

	; save SP
	in YL, _SFR_IO_ADDR(SPL)
	in YH, _SFR_IO_ADDR(SPH)	; load the value of the stack pointer
	ldi ZL, lo8(proc_sp)
	ldi ZH, hi8(proc_sp)		; load address of proc_sp pointer
	ld XL, Z+
	ld XH, Z					; load value of pointer, i.e., address of proc_sp
	st X+, YL
	st X, YH					; store SP value to proc_sp

	; save PC
	ldd XL, Y+1
	ldd XH, Y+2					; load the PC value into Z
	ldi ZL, lo8(proc_pc)
	ldi ZH, hi8(proc_pc)		; load address to proc_pc pointer
	ld YL, Z+
	ld YH, Z					; load value of pointer, i.e., address of proc_pc
	st Y+, XL
	st Y, XH					; store PC in proc_pc
	
	; save SREG
	in XL, _SFR_IO_ADDR(SREG)	; load SREG value (1 byte)
	ldi ZL, lo8(proc_sreg)
	ldi ZH, hi8(proc_sreg)		; load address to proc_sreg pointer
	ld YL, Z+
	ld YH, Z					; load value of pointer, i.e., address of proc_sreg
	st Y, XL					; store SREG value in proc_sreg

	call switch_context			; call C function to perform the context switch


restore_process_state:
	; NOTE: we do NOT comply with calling conventions here, maybe fix?
	; restore SP
	ldi ZL, lo8(proc_sp)
	ldi ZH, hi8(proc_sp)		; load address of proc_sp pointer
	ld XL, Z+
	ld XH, Z					; load value of pointer, i.e., address of proc_sp
	ld ZL, X+
	ld ZH, X					; load value of proc_sp
	out _SFR_IO_ADDR(SPL), ZL
	out _SFR_IO_ADDR(SPH), ZH	; write proc_ps to SP

	; restore PC
	ldi ZL, lo8(proc_pc)
	ldi ZH, hi8(proc_pc)		; load address to proc_pc pointer
	ld XL, Z+
	ld XH, Z					; load value of pointer, i.e., address of proc_pc
	ld ZL, X+
	ld ZH, X					; load value of proc_pc
	push ZH
	push ZL						; push PC to stack

	; restore SREG
	ldi ZL, lo8(proc_sreg)
	ldi ZH, hi8(proc_sreg)		; load address to proc_sreg pointer
	ld YL, Z+
	ld YH, Z					; load value of pointer, i.e., address of proc_sreg
	ld XL, Y					; load SREG value from proc_sreg
	out _SFR_IO_ADDR(SREG), XL	; store SREG value (1 byte)

	; restore registers
	ldi ZL, lo8(proc_registers)
	ldi ZH, hi8(proc_registers)	; load address of the pointer to proc_registers vector
	ld YL, Z+
	ld YH, Z					; load address of the proc_registers vector

	ldd ZL, Y+30
	ldd ZH, Y+31
	push ZH
	push ZL						; store Z register on stack temp.
	movw Z, Y

	ld r0, Z+
	ld r1, Z+
	ld r2, Z+
	ld r3, Z+
	ld r4, Z+
	ld r5, Z+
	ld r6, Z+
	ld r7, Z+
	ld r8, Z+
	ld r9, Z+
	ld r10, Z+
	ld r11, Z+
	ld r12, Z+
	ld r13, Z+
	ld r14, Z+
	ld r15, Z+
	ld r16, Z+
	ld r17, Z+
	ld r18, Z+
	ld r19, Z+
	ld r20, Z+
	ld r21, Z+
	ld r22, Z+
	ld r23, Z+
	ld r24, Z+
	ld r25, Z+
	ld r26, Z+
	ld r27, Z+
	ld r28, Z+
	ld r29, Z+
	pop r30
	pop r31					; restore Z register
	
;	sei						; re-enable interrupts
	reti					; jump to the pushed PC value, and enable interrupts
							; this is the current PC of the process to be run
