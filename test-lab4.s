;# sa se afiseze cat si rest din media aritmectica din vector

;# ex : 6   1 4 9 10 4 5     (5,3)    pt ca suma e 33

.data

n: .space 4

a: .space 4

s: .space 4

cat: .space 4

rest: .space 4

sir: .space 800

.text



.global main

main:



pushl $n

call scanf

popl %ebx

popl %ebx



lea sir, %esi

xorl %ecx, %ecx

for_citire:

    cmp n, %ecx

    je exit_for_citire



    pusha

    pushl $a

    call scanf

    popl %ebx

    popl %ebx

    popa



    movl a, %eax

    movl %eax, (%esi, %ecx, 4)

    incl %ecx

    jmp for_citire

exit_for_citire:





xorl %ecx, %ecx

lea sir, %esi

loop:

      ;# ecx este 1, 4, 9, 10, 4, 5



    cmp n, %ecx

    je end_loop

    xorl %edx,%edx

    movl (%edi,%ecx,4), %eax

    addl s, %ebx

    movl %ecx, %ebx

    

incl %ecx

jmp loop

end_loop:





lea sir, %esi

xorl %ecx, %ecx

movl s, %eax

movl $0, %edx

divl n

movl %eax, cat

movl %edx, rest



mov $4, %eax

mov $1, %ebx

movl cat, %ecx

mov $15, %edx

int $0x80



mov $4, %eax

mov $1, %ebx

movl rest, %ecx

mov $15, %edx

int $0x80



exit:

movl $1, %eax

xorl %ebx, %ebx

int $0x80
