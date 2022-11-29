;# sa se afiseze cat si rest din media aritmectica din vector

;# ex : 6   1 4 9 10 4 5     (5,3)    pt ca suma e 33

.data

n: .space 4

a: .space 4

s: .space 4

cat: .space 4

rest: .space 4

sir: .space 800

fs1: .asciz "%ld"

print: .asciz "%ld\n"

.text



.global main

main:



pushl $n

push $fs1

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

    push $fs1

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

movl %ecx, s

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

movl n,%ebx

movl s, %eax

movl $0, %edx

divl %ebx

movl %eax, cat

movl %edx, rest



pushl $cat

pushl $print

call printf

popl %ebx

popl %ebx



pushl $rest

pushl $print

call printf

popl %ebx

popl %ebx



exit:

movl $1, %eax

xorl %ebx, %ebx

int $0x80
