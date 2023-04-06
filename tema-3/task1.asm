section .text
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

	; find the node with the max value
	xor eax, eax ; eax = max node
	xor ebx, ebx ; ebx = iterator

	; assume first element is max
	lea eax, [esi] 

	; iterate the array to find the node with the max value
	for1:
		lea edx, [esi + ebx * 8] ; node[i]
		mov ecx, [eax] 

		; if(node[i]->val > max_node->val)
		cmp [edx], ecx ; compare current node's value to max's value
		jle inc_for
		; max = node[i]
		mov eax, edx

	inc_for:
	inc ebx
	mov ecx, [ebp + 8]
	cmp ebx, ecx
	jl for1

	; iterate the array to find the node with the next max value(old max - 1)
	xor ebx, ebx
	for2:
		; edi = old max value - 1
		mov edi, [eax]
		dec edi

		lea edx, [esi + ebx * 8] ; current node
		cmp [edx], edi ; compare current node's value to the max value to be found
		jne inc_for2

		; set next
		; new_max->next = old_max
		mov [edx + 4], eax

		; old_max = new_max
		mov eax, edx

		; stop when max = 1
		mov edx, 1
		cmp [eax], edx
		je end
		xor ebx, ebx
		jmp for2
		
	inc_for2:
	inc ebx
	jmp for2

	end:

	leave
	ret
