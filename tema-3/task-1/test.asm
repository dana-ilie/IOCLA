%include "../../utils/printf32.asm"

section .text
	extern printf
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	mov ecx, [ebp + 8] ; n
	mov esi, [ebp + 12] ; node

	xor eax, eax ; eax = max
	xor ebx, ebx ; i 

	;; gasesc max
	lea eax, [esi] 

	for1:
		;;if(node[i].val > max)
		;;	max = node[i]
		lea edx, [esi + ebx * 8] ; node[i]
		mov ecx, [eax]
		cmp [edx], ecx
		jle inc_for
		mov eax, edx

	inc_for:
	inc ebx
	mov ecx, [ebp + 8]
	cmp ebx, ecx
	jl for1

	PRINTF32 `tail <=>max = %d \n\x0`, [eax]


	;; parcurg lista si caut new_max de n - 1 ori

	xor ebx, ebx ; ebx = i / j
	for2:  ; for (i = 0; i < n - 1; i++)
		push ebx
		PRINTF32 `i = %d \n\x0`, ebx


		xor edx, edx ; edx = new_max
		lea edx, [esi]
		;;find min
		xor edi, edi
		for4:
		push edi
			lea ecx,  [esi + edi * 8]
			mov edi, [edx]
			cmp [ecx], edi
			jge inc_for4
			mov edx, ecx

		inc_for4:
		pop edi
		inc edi
		mov ecx, [ebp + 8]
		cmp edi, ecx
		jl for4
    
		PRINTF32 `min = %d \n\x0`, [edx]


		lea edx, [esi + 8]
		xor ebx, ebx ; for (j = 0; j < n; j++)
		for3:
		PRINTF32 `j = %d \n\x0`, ebx
		
			;;if (node[i] < max && node[i].val > new_max)
			;;	new_max = node[i]
			lea ecx, [esi + ebx * 8] ;node[i]
			mov edi, [eax]
			PRINTF32 `node[i] = %d \n\x0`, [ecx]
			PRINTF32 `max = %d \n\x0`, edi
			cmp [ecx], edi
			jge inc_for3
			mov edi, [edx]
			PRINTF32 `new_max = %d \n\x0`, [ecx]
			PRINTF32 `max] = %d \n\x0`, edi
			cmp [ecx], edi
			jle inc_for3
			PRINTF32 `bag pula \n\x0`
			mov edx, ecx

		inc_for3:
		inc ebx
		mov ecx, [ebp + 8]
		cmp ebx, ecx
		jl for3

		PRINTF32 `new_max = %d \n\x0`, [edx]
		;; new_max->next = max
		;;mov ecx, edx
		;;add ecx, 4
		mov [edx + 4], eax
		mov edi, [edx + 4]
		PRINTF32 `new_max->next = %d \n\x0`, [edi]

		;; max = new_max
		mov eax, edx
		PRINTF32 `max=new_max = %d \n\x0`, [eax]
		mov edi, 1
		cmp [eax], edi
		je end
	

	pop ebx
	inc ebx
	mov ecx, [ebp + 8]
	dec ecx
	cmp ebx, ecx
	jl for2

	end:
	PRINTF32 `head = %d \n\x0`, [eax]
	mov ebx, [eax + 4]
	PRINTF32 `head = %d \n\x0`, [ebx]
	add eax, 8
	PRINTF32 `head = %d \n\x0`, eax








xor ebx, ebx
	for:
		lea edx, [esi + ebx * 8]
		cmp [edx], ecx
		je end_for
	inc ebx
	cmp ebx, ecx
	jl for
	end_for:
	mov eax, edx
	xor ebx, ebx

	for2:
		mov edi, [eax]
		dec edi

		lea edx, [esi + ebx * 8]
		cmp [edx], edi
		je end_for2
	inc ebx
	jmp for2

	end_for2:
		mov [edx + 4], eax
		mov eax, edx
		mov edx, 1
		cmp [eax], edx
		je end
		xor ebx, ebx
		jmp for2

	end:








	----------------------------------------------------------------------------------
	%include "../../utils/printf32.asm"
section .text
	extern printf
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0
	mov esi, [ebp + 12] ; node
	
	mov ebx, 1 ; first value to find
	xor ecx, ecx ; counter
	
	; find the node with the value 1 (first node) 
find_first:
	lea edx, [esi + ecx * 8] ; get the first node
	cmp [edx], ebx ; compare it's value to 1
	je save_first 
	inc ecx
	jmp find_first

; save the reference to the first node 
save_first:
	mov eax, edx ; move value from edx (found above) to eax
	push eax ; save it to stack


	xor ecx, ecx ; counter

; calculate the next value
next_value:
	mov edi, [eax] ; move the first node' value to edi
	inc edi ; get the next value (ex. [eax] = 1 -> edi = 2)

create_list: 
	lea edx, [esi + ecx * 8] ; get the nodes in the given order
	cmp [edx], edi ; compare current node's value to the reference value
	je copy 
	inc ecx
	jmp create_list

; place the found node to the end of the list
copy:
	mov [eax + 4], edx ; set the reference form the last node in list to the new node
	mov eax, edx ; the new node becomes the last node

	mov edx, [ebp + 8] ; get the list's length
	cmp [eax], edx ; check for unsorted nodes
	je end_program ; end program if the list is sorted
	xor ecx, ecx ; set counter to 0 again
	jmp next_value

end_program:
	pop eax ; go to the first node in the sorted list

	leave
	ret



	leave
	ret
