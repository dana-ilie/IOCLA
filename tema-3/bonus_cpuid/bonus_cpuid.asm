section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	pushad

	mov esi, dword[ebp + 8] ;put in esi de argument of the function(the string)

	mov eax, 00h
	cpuid
	mov dword[esi], ebx
	add esi, 4
	mov dword[esi], edx
	add esi, 4
	mov dword[esi], ecx

	popad
	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0
	pushad

	mov eax, 1
	cpuid
	; use mask and right shift to obtain bit 5 for vmx
	and ecx, 0x20
	shr ecx, 5 
	mov edx, dword[ebp + 8]
	mov dword[edx], ecx

	xor ecx, ecx
	mov eax, 1
	cpuid
	; use mask and right shift to obtain bit 30 for rdrand
	and ecx, 0x40000000
	shr ecx, 30
	mov edx, dword[ebp + 12]
	mov dword[edx], ecx

	xor ecx, ecx
	mov eax, 1
	cpuid
	; use mask and right shift to obtain bit 28 for avx
	and ecx, 0x10000000
	shr ecx, 28
	mov edx, dword[ebp + 16]
	mov dword[edx], ecx

	popad
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	pushad

	xor ecx, ecx
	mov eax, 0x80000006
	cpuid
	; use mask to obtain bits [7:0]
	and ecx, 0xff
	mov edx, dword[ebp + 8]
	mov dword[edx], ecx

	xor ecx, ecx
	mov eax, 0x80000006
	cpuid
	; use mask and right shift to obtain bits [31:16]
	and ecx, 0xffff0000
	shr ecx, 16
	mov edx, dword[ebp + 12]
	mov dword[edx], ecx

	popad
	leave
	ret
