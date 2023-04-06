section .data
    extern len_cheie, len_haystack
    nr_lines dd 0
    i dd 0
    k dd 0

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE
    
    xor eax, eax
    xor ecx, ecx
    xor edx, edx

    mov dword[i], 0

    ;; for(i = 0; i < len_cheie; i++)
    repeat1:
        
        ;; calculate number of lines
        mov eax, dword[len_haystack]
        xor edx, edx
        div dword[len_cheie]
        inc eax
        mov dword[nr_lines], eax
        
        ;; if the column has last element empty
        xor eax, eax
        xor ecx, ecx
        mov eax, dword[i]
        mov ecx, dword[edi + 4 * eax] ;key[i]
        inc ecx
        cmp ecx, edx
        jle continue
        ;; nr_lines--
        dec dword[nr_lines]

        xor eax, eax
        xor ecx, ecx
        xor edx, edx

    continue:
        mov dword[k], 0
        ;; for (k = 0; k < nr_lines; k++)
        repeat2:
            ;; key[i]
            mov eax, dword[i]
            mov ecx, dword[edi + 4 * eax]
            ;; k * len_cheie
            mov eax, dword[k]
            mul dword[len_cheie]

            ;; key[i] + k * len_cheie
            add eax, ecx
            mov dl, byte[esi + eax]
            mov byte[ebx], dl
            inc ebx
            
            add dword[k], 1
            mov eax, dword[k]
            cmp eax, [nr_lines]
            jl repeat2

        add dword[i], 1
        mov eax, dword[i]
        cmp eax, [len_cheie]
        jl repeat1
    
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY