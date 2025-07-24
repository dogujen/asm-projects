section .data
    mesaj1 db "Birinci sayi: ", 0
    mesaj2 db "Ikinci sayi: ", 0
    mesaj3 db "Islem secin (+, -, *, /): ", 0
    mesaj_sonuc db "Sonuc: ", 0
    mesaj5 db "Ondalik ciktinin sadece tam sayi kismini alirsiniz.",10,0
    mesaj_bolme_hata db "Hata: 0'a bolunemez :)!", 10, 0
    satir db 10, 0
    girdi_arabellek db 20

section .bss
    sayi1 resd 1
    sayi2 resd 1
    sonuc resd 1
    islem resb 1

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, mesaj5
    mov rdx, 52
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, mesaj1
    mov rdx, 15
    syscall

    call sayi_oku
    mov [sayi1], eax

    ; İkinci
    mov rax, 1
    mov rdi, 1
    mov rsi, mesaj2
    mov rdx, 14
    syscall

    call sayi_oku
    mov [sayi2], eax

    ; islem
    mov rax, 1
    mov rdi, 1
    mov rsi, mesaj3
    mov rdx, 27
    syscall

    ; oku 
    mov rax, 0
    mov rdi, 0
    mov rsi, islem
    mov rdx, 1
    syscall

    ; al
    mov eax, [sayi1]
    mov ebx, [sayi2]
    mov cl, byte [islem]

    cmp cl, '+'
    je .topla
    cmp cl, '-'
    je .cikar
    cmp cl, '*'
    je .carp
    cmp cl, '/'
    je .bol
    jmp _cikis

.topla:
    add eax, ebx
    jmp .sonuc_goster

.cikar:
    sub eax, ebx
    jmp .sonuc_goster

.carp:
    imul eax, ebx
    jmp .sonuc_goster

.bol:
    cmp ebx, 0
    je .bolme_hata
    xor edx, edx
    idiv ebx
    jmp .sonuc_goster

.bolme_hata:
    mov rax, 1
    mov rdi, 1
    mov rsi, mesaj_bolme_hata
    mov rdx, 24
    syscall
    jmp _cikis

.sonuc_goster:
    mov [sonuc], eax

    ; "Sonuc: " yaz
    mov rax, 1
    mov rdi, 1
    mov rsi, mesaj_sonuc
    mov rdx, 8
    syscall

    ; sonucu yaz
    mov eax, [sonuc]
    call sayi_yaz

    ; newline
    mov rax, 1
    mov rdi, 1
    mov rsi, satir
    mov rdx, 1
    syscall

_cikis:
    mov rax, 60
    xor rdi, rdi
    syscall


sayi_oku:
    mov rax, 0
    mov rdi, 0
    mov rsi, girdi_arabellek
    mov rdx, 20
    syscall

    mov rsi, girdi_arabellek
    xor eax, eax
    xor ecx, ecx

.giris:
    mov cl, byte [rsi]
    cmp cl, 10
    je .bitti
    cmp cl, 0
    je .bitti
    sub cl, '0'
    imul eax, eax, 10
    add eax, ecx
    inc rsi
    jmp .giris

.bitti:
    ret

sayi_yaz:
    lea rcx, [girdi_arabellek + 19]
    mov byte [rcx], 0
    dec rcx

    cmp eax, 0
    jne .yazdir_dongu
    mov byte [rcx], '0'
    jmp .yazdir

.yazdir_dongu:
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    mov [rcx], dl
    dec rcx
    test eax, eax
    jnz .yazdir_dongu
    inc rcx

.yazdir:
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    lea rdx, [girdi_arabellek + 20]
    sub rdx, rcx
    syscall
    ret
