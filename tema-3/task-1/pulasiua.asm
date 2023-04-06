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