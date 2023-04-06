; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

section .data
    month times 12 dw 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    month_len dw 12
    len dd 0

    current_day dw 0
    current_month dw 0
    current_year dd 0

    birth_day dw 0
    birth_month dw 0
    birth_year dd 0

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

    ;; ebx = all ages
    xchg ebx, ecx
    xor ecx, ecx
    xor eax, eax
    mov [len], edx

    ;; iterate with ecx
    repeat:
        mov ax, word[esi + my_date.day]
        mov [current_day], ax
        xor eax, eax

        mov ax, word[esi + my_date.month]
        mov [current_month], ax
        xor eax, eax

        mov eax, dword[esi + my_date.year]
        mov [current_year], eax
        xor eax, eax

        ;; if (birth_day > current_day)
        mov ax, word[edi + ecx * my_date_size + my_date.day]
        cmp ax, [current_day]
        jle jump1
        ;; current_day = current_day + month[birth_month - 1]
        xor eax, eax
        mov ax, word[edi + ecx * my_date_size + my_date.month]
        dec ax
        mov dx, word[month + eax * 2]
        add [current_day], dx
        xor eax, eax
        xor edx, edx

        ;; current_month = current_month - 1
        mov ax, word[current_month]
        dec ax
        mov word[current_month], ax
        xor eax, eax
        jmp jump1

    jump1:
        ;; if (birth_month > current_month)
        mov ax, word[edi + ecx * my_date_size + my_date.month]
        cmp ax, [current_month]
        jle jump2
        ;; current_year = current_year - 1
        xor eax, eax
        mov eax, dword[current_year]
        dec eax
        mov dword[current_year], eax
        xor eax, eax

        ;; current_month = current_month + 12
        mov ax, word[current_month]
        add ax, 12
        mov word[current_month], ax
        xor eax, eax
        jmp jump2

    jump2:
        ;; calculated_year = current_year - birth_year
        mov eax, dword[current_year]
        sub eax, dword[edi + ecx * my_date_size + my_date.year]
        cmp eax, 0
        jge add_year
        mov dword[ebx + 4 * ecx], 0
        jmp incr

    add_year:
        mov dword[ebx + 4 * ecx], eax
        jmp incr

    incr:    
        inc ecx;
        cmp ecx, [len] 
        jl repeat


    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
