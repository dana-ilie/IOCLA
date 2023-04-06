pushl 	%ebp
	movl	%esp, %ebp
	
	movl 8(%ebp), %eax
	movl 12(%ebp), %ebx
	movl 20(%ebp), %edi
	xorl %esi, %esi

for:
	movl (%eax), %ecx
	movl (%ebx), %edx
	addl %edx, %ecx
	movl %ecx, (%edi)
	addl $4, %edi
	addl $4, %eax
	addl $4, %ebx
	incl %esi 
	cmpl 16(%ebp), %esi
	jl for

	movl 20(%ebp), %edi
	movl 16(%ebp), %esi

	movl $FIRST_POSITION, %eax

	mull %esi
	movl $10, %ebx
	divl %ebx

	subl $FIRST_VALUE, (%edi, %eax, 0x4)

	movl $SECOND_POSITION, %eax

	mull %esi
	movl $10, %ebx
	divl %ebx

	subl $SECOND_VALUE, (%edi, %eax, 0x4)

	movl $THIRD_POSITION, %eax

	mull %esi
	movl $10, %ebx
	divl %ebx

	subl $THIRD_VALUE, (%edi, %eax, 0x4)