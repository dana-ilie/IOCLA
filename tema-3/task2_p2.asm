section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	push ebp
	push esp
	pop ebp

	push dword[ebp + 8]
	pop ebx ; ebx = str_length
	push dword[ebp + 12]
	pop esi ; esi = str
	
	;; assume the brackets are balanced
	xor eax, eax
	inc eax ; eax = flag = 1

	xor edx, edx
	xor ecx, ecx

	;for(i = 0; i < str_length; i++)
	for:
		; check if the current bracket is open
		cmp byte[esi + ecx], 0x28 ; if (s[i] == '(')
		jne else
		push 0x28 ; push the open bracket on stack
		jmp inc_for

		else:
			cmp ebp, esp ; if stack is not empty
			je else2
			pop edx
			cmp edx, 0x28 ; if stack.top == '('
			jne else2
			jmp inc_for

			else2:
				; flag = 0 => the brackets are not balanced
				xor eax, eax
				jmp end

	inc_for:
	inc ecx
	cmp ecx, ebx
	jl for

	; check if stack is empty
	cmp ebp, esp
	je end
	; if stack is not empty then the brackets are not balanced
	xor eax, eax
	
	end:
	
	pop ebp
	ret
