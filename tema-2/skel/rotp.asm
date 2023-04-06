section .text
    global rotp

section .data
    len dd 0

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implment rotp
    ;; FREESTYLE STARTS HERE

    mov dword[len], ecx
    xor ecx, ecx
    repeat:
        mov ah, byte[esi + ecx]
        mov ebx, dword[len]
        sub ebx, ecx
        sub ebx, 1
        mov al, byte[edi + ebx]
        xor ah, al
        mov byte[edx + ecx], ah
        inc ecx
        cmp dword[len], ecx
        jg repeat
        
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY