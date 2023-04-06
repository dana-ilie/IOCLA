#include "positions.h"
.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl 	%ebp
	movl	%esp, %ebp
	
	movl 8(%ebp), %eax // first array
	movl 12(%ebp), %ebx // second array
	movl 20(%ebp), %edi // result array
	xorl %esi, %esi // counter

for:
	movl (%eax), %ecx // get the current elem from the first array
	movl (%ebx), %edx // get the current elem from the second array
	addl %edx, %ecx // add them togheter
	movl %ecx, (%edi) // place the result in the result array
	addl $4, %edi // go to the next pos in result array
	addl $4, %eax // go to the next pos in first array
	addl $4, %ebx // go to the next pos in second array
	incl %esi // counter
	cmpl 16(%ebp), %esi // check if no elems left in the arrays
	jl for

	movl 20(%ebp), %edi // result array
	movl 16(%ebp), %esi // length of the arrays

	movl $FIRST_POSITION, %eax // get the first pos

	mull %esi // multiply the first pos by the size of the array
	movl $10, %ebx // copy the scale number to ebx (standard = 10)
	divl %ebx // divide the result by the scale number

	subl $FIRST_VALUE, (%edi, %eax, 0x4) // place the first value to the resulted pos

	// same as above for the second substraction
	movl $SECOND_POSITION, %eax

	mull %esi
	movl $10, %ebx
	divl %ebx

	subl $SECOND_VALUE, (%edi, %eax, 0x4)

	// same as above for the third substraction
	movl $THIRD_POSITION, %eax

	mull %esi
	movl $10, %ebx
	divl %ebx

	subl $THIRD_VALUE, (%edi, %eax, 0x4)

	leave
	ret