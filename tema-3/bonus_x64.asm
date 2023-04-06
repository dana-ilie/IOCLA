section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0
	; rdi = v1
	; rsi = n1
	; rdx = v2
	; rcx = n2
	; r8 = v

	; find the minimum number of elements of an array (n1 or n2)
	xor r10, r10
	; assume the minimum is n2
	mov r10, rcx

	; if (n1 < n2)
	cmp rsi, rcx
	jg n2_min
	; min = n1
	mov r10, rsi

	n2_min:
	xor r11, r11 ; iterator
	; iterate min number of elements of each array
	; add these elements to v array
	for:
		mov ebx, dword[rdi]
		mov dword[r8], ebx ; add an element of v1 array to v array
		add r8, 4
		add rdi, 4

		xor ebx, ebx
		mov ebx, dword[rdx]
		mov dword[r8], ebx ; add an element of v2 array to v array
		add r8, 4
		add rdx, 4

	inc r11
	cmp r11, r10
	jl for


	; add the remaining elements of the array with the most elements
	cmp rsi, rcx
	jl add_v2
	jmp add_v1

	; add the remaining elements of v2 array
	add_v2:
		mov r10, rcx
		for2:
			mov ebx, dword[rdx]
			mov dword[r8], ebx ; add an element of v2 array to v array
			add r8, 4
			add rdx, 4

		inc r11
		cmp r11, r10
		jl for2
		jmp end

	; add the remaining elements of v1 array
	add_v1:
		mov r10, rsi
		for3:
			mov ebx, dword[rdi]
			mov dword[r8], ebx ; add an element of v1 array to v array
			add r8, 4
			add rdi, 4
		
		inc r11
		cmp r11, r10
		jl for3
		jmp end

	end:

	leave
	ret
