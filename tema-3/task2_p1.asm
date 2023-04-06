section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	push ebp
	push esp
	pop ebp

	push dword[ebp + 8]
	pop esi ; esi = a
	push dword[ebp + 12]
	pop edi ; edi = b

	xor eax, eax ;eax = cmmmc
	xor ebx, ebx ;ebx = max
	xor ecx, ecx ;ecx = flag
	inc ecx

	; max = max(a,b)
	cmp esi, edi
	jle maxb
	jmp maxa

	maxb:
		; max = b
		push edi
		pop ebx
		jmp while
	maxa:
		; max = a
		push esi
		pop ebx
		jmp while

	; while (ecx == 1)
	while:
		cmp ecx, 1
		jne end_while

		push ebx
		pop eax ;eax = max copy
		xor edx, edx
		div esi
		; if (max % a == 0)
		cmp edx, 0
		jne inc_max
		
		push ebx
		pop eax ;eax = max copy
		xor edx, edx
		div edi
		; if (max % b == 0)
		cmp edx, 0
		jne inc_max
		; cmmmc = max
		push ebx
		pop eax
		; flag = 0 => break
		xor ecx, ecx

	inc_max:
		; max++
		inc ebx
		jmp while
	
	end_while:

	pop ebp

	ret
