section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	; replace enter 0, 0
	push ebp
	push esp
	pop ebp

	; put first argument in ebx using stack
	push dword[ebp + 8]
	pop ebx
	; put second argument in edx using stack
	push dword[ebp + 12]
	pop edx

	xor ecx, ecx ; counter
; check if the current element is an opened bracket
check_brackets:
	cmp byte[edx + ecx], 0x28 ; compare with the ascii code of "("
	jne closed_brackets
	push eax ; push something on stack (already checked for "(") -> eax value = irrelevant
	inc ecx
	cmp ecx, ebx ; check for the end of the string
	jl check_brackets
	jmp check_stack

; if the current char is not "(", check if it is ")"
closed_brackets:
	cmp ebp, esp ; check if the stack is empty
	je wrong_closing ; if it is -> unbalanced brackets
	cmp byte[edx + ecx], 0x29 ; compare with the ascii code of ")"
	jne wrong_closing ; if not -> wrong char -> invalid input
	pop edi ; pop from stack (the value does not matter)
	inc ecx
	cmp ecx, ebx ; check for the end of the string
	jl check_brackets 
	jmp check_stack

wrong_closing:
	xor eax, eax ; return 0 -> unbalanced
	jmp end_program

; check for any "(" left on stack
check_stack:
	cmp ebp, esp ; check if the stack is empty
	jne wrong_closing ; if not -> unbalanced
	xor eax, eax
	inc eax ; balanced brackets
end_program:

	pop ebp
	ret