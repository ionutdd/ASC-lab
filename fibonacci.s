;# creati o functie recursiva care calculeaza Fibnoacci luand doar n-ul, si ea returneaza 
;#al n-lea termen din Fibonacci
.data
n: .space 4
a: .space 4
cit: .asciz "%ld"
afis: .asciz "%ld\n"
aafis: .asciz "Al %ld-lea element din sirul lui Fibonacci este %ld\n"
.text
fibonacci:
	pushl %ebp
	movl %esp, %ebp
	
	
	movl 8(%ebp), %ecx
	
	;# fib(0)
	
	cmp $0, %ecx
	jne verif
	
	movl $0, %esi
	jmp exit_fibonacci
	
	;# fib(1)
	
	verif:
	cmp $1, %ecx
	jne continue
	
	movl $1, %esi
	jmp exit_fibonacci
	
	
	continue:
		;#fibonacci(n-1)
	
		decl %ecx
		movl %ecx, -4(%ebp)
		movl %ecx, %edx
		pushl %edx
		call fibonacci
		popl %ebx
		addl %esi, %eax
		movl -4(%ebp), %ecx
		
		;#fibonacci(n-2)
		decl %ecx
		movl %ecx, %edi
		pushl %edi
		call fibonacci
		popl %ebx
		
		
		
	exit_fibonacci:
	popl %ebp
ret
	
	
.global main
main:
pushl $n
pushl $cit
call scanf
popl %ebx
popl %ebx
;# cazurile cand n=0 sau n=1
movl n, %eax
cmp $0, %eax
je afisarea
cmp $1, %eax
je afisarea
xorl %eax, %eax
fib:
pushl n
call fibonacci
popl %ebx
;#afisarea 
afisarea:
;# adaugam un 1 cand n e impar
xorl %ebx, %ebx
movl %eax, %ebx
movl n, %eax
xorl %edx, %edx
movl $2, %ecx
div %ecx
addl %ebx, %edx
movl %edx, %eax
pushl %eax    ;# rezultatul e in eax
pushl n
pushl $aafis
call printf
addl $12, %esp

exit:
movl $1, %eax
xorl %ebx, %ebx
int $0x80
