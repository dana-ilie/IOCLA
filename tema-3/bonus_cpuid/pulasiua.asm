section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0
	push r8 ; save the state of the result array
	xor r10, r10 ; counter for the first array
	xor r11, r11 ; counter for the second array
for
	mov eax, dword[rdi] ; get the current element from the array
	mov dword[r8], eax ; place the element to the result array
	add rdi, 4 ; go to the next pos in the first array
	inc r10 ; counter
	add r8, 4 ; go to the next pos in the result array
	cmp r10, rsi ; check if any left elements in the first array
	je add_v2

	mov eax, dword[rdx] ; get the current element from the second array
	mov dword[r8], eax ; place the elemenet to the array result
	add rdx, 4 ; go to the next pos in the first array
	inc r11 ; counter
	add r8, 4 ; go to the next pos in the result array
	cmp r11, rcx ; check if any left elements in the second array
	je add_v1

	jmp for

; called when the second array has no elements left (add the rest from array 1)
; add the elements same as above
add_v1:
	mov eax, dword[rdi]
	mov dword[r8], eax
	add rdi, 4
	inc r10
	add r8, 4
	cmp r10, rsi
	je end_program
	jmp add_v1

; called when the first array has no elements left (add the rest from array 2)
; add the elements ass above
add_v2:
	mov eax, dword[rdx]
	mov dword[r8], eax
	add rdx, 4
	inc r11
	add r8, 4
	cmp r11, rcx
	je end_program
	jmp add_v2


end_program:

	; restore the state of the result array from the begining 
	pop r8

	leave
	ret