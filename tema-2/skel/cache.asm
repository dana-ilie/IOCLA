;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS


section .text
    global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE

    xor eax, eax

    ;; calculate tag
    shr edx, 3

    ;; search tag in tags vector
    ;; if it's not in the vector => cache miss

    search_tags:
        cmp edx, dword[ebx]
        je cache_hit
        add ebx, 4

        inc eax
        cmp eax, CACHE_LINES
        jl search_tags
    
    ;; cache miss:
    ;; add tag in tags vector on to_replace position

    xor eax, eax
    mov ebx, [ebp + 12]

    ;; search add position
    repeat2:
        add ebx, 4
        add ecx, 8

        inc eax
        cmp eax, edi
        jl repeat2

    ;; add in vector
    mov dword[ebx], edx

    ;; copy the bytes in cache on to_replace line
    shl edx, 3
    xor ebx, ebx
    xor eax, eax
    copy:
        mov bl, byte[edx]
        mov byte[ecx], bl
        inc ecx
        inc edx

        inc eax
        cmp eax, CACHE_LINE_SIZE
        jl copy

    cache_hit:
    mov ebx, [ebp + 12] ;tags
    xor eax, eax
    mov edx, [ebp + 20] ;address
    shr edx, 3
        repeat3:
            cmp dword[ebx], edx
            je index_found
            add ebx, 4

            inc eax
            cmp eax, CACHE_LINES
            jl repeat3

    index_found:
        ;; search in cache on eax index
        xor ebx, ebx
        mov ecx, [ebp + 16]
        repeat4:
            add ecx, 8
            inc ebx
            cmp ebx, eax
            jl repeat4
        
        mov edx, [ebp + 20] ;address
        and edx, 0x00000007
        add ecx, edx

        mov eax, [ebp + 8]
        xor ebx, ebx
        mov bl, byte[ecx]
        mov byte[eax], bl

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
