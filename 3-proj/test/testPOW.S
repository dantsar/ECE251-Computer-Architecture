	.arch armv5t
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"testPOW.c"
	.text
	.section	.rodata
	.align	2
.LC0:
	.ascii	"%f\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu vfp
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	mov	r3, #1073741824
	str	r3, [fp, #-12]	@ float
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L2
.L3:
	vldr.32	s15, [fp, #-12]
	vldr.32	s14, .L5+8
	vadd.f32	s15, s15, s14
	vstr.32	s15, [fp, #-12]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L2:
	ldr	r3, [fp, #-8]
	cmp	r3, #1
	ble	.L3
	vldr.32	s15, [fp, #-12]
	vcvt.f64.f32	d7, s15
	vldr.64	d1, .L5
	vmov.f64	d0, d7
	bl	pow
	vmov.f64	d7, d0
	vcvt.f32.f64	s15, d7
	vstr.32	s15, [fp, #-12]
	vldr.32	s15, [fp, #-12]
	vcvt.f64.f32	d7, s15
	vmov	r2, r3, d7
	ldr	r0, .L5+12
	bl	printf
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L6:
	.align	3
.L5:
	.word	0
	.word	1073741824
	.word	1073741824
	.word	.LC0
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 7.4.0-1ubuntu1~18.04.1) 7.4.0"
	.section	.note.GNU-stack,"",%progbits
