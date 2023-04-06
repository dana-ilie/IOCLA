global get_words
global compare_func
global sort

section .data
    delim db " ,.\0", 0

section .text
    extern strtok
    extern qsort
    extern strlen
    extern strcmp

compare_func:
    push ebp
    mov ebp, esp
    push ebx
    push ecx

    mov ebx, [ebp + 8] ; first word to be compared
    mov ecx, [ebp + 12] ; second word to be compared

    xor eax, eax
    inc eax
    
    push dword[ebx]
    call strlen ; calculate the length of the first word
    add esp, 4
    mov ebx, eax ; ebx = the length of the first word
    
    mov ecx, [ebp + 12]
    push dword[ecx]
    call strlen ; calculate the length of the second word
    add esp, 4
    mov ecx, eax ; ecx = the length of the second word

    cmp ebx, ecx ; compare the two lengths
    je lexico ; the words have the same length
    jl less

    greater:
        mov eax, 1
        jmp end

    less:
        mov eax, -1
        jmp end

    lexico:
        ; sort words lexicographically
        mov ebx, [ebp + 8] ; first word to be compared
        mov ebx, [ebx]
        mov ecx, [ebp + 12] ; second word to be compared
        mov ecx, [ecx]
        ; push the words on the stack in order to call strcmp function
        push ecx
        push ebx
        call strcmp
        add esp, 8

    end:
    pop ecx
    pop ebx
    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    push ebx

    mov ebx, [ebp + 8] ; words
    mov ecx, [ebp + 12] ; nr_words
    mov edx, [ebp + 16] ; size

    ; push the arguments of the qsort function on the stack
    push compare_func
    push edx
    push ecx
    push ebx
    call qsort ; call the qsort function

    pop ebx
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov ebx, [ebp + 8] ; s
    mov esi, [ebp + 12] ; words
    mov ecx, [ebp + 16]; nr_words

    push esi ; save esi on the stack

    mov edx, delim
    ; push the arguments of the strtok function on the stack
    push edx
    push ebx
    ; call the strtok function
    call strtok
    add esp, 8
    pop esi
    mov [esi], eax ; add the first word in the words array
    add esi, 4

    ; add the rest of the words in the words array
    xor edx, edx ; edx = iterator
    for:
    push edx ; save iterator's value on the stack

        push esi ; save esi in the stack

        mov edx, delim
        ; push the arguments of the strtok function on the stack
        push edx
        push 0x00 ; push NULL
        ; call the strtok function
        call strtok
        add esp, 8
        pop esi
        mov [esi], eax ; add the current word in the words array
        add esi, 4

    pop edx
    inc edx
    mov ecx, [ebp + 16]; nr_words
    dec ecx
    cmp edx, ecx
    jl for

    leave
    ret
