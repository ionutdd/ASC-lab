.data



c: .space 4

n: .space 4

a: .space 4

p: .space 4

k: .space 4

st: .space 4

dr: .space 4

m1: .space 160000

m2: .space 160000

mres: .space 160000

columnIndex: .space 4

lineIndex: .space 4

vec: .space 400

cit: .asciz "%ld"

afis: .asciz "%ld\n"

afismat: .asciz "%ld "

newLine: .asciz "\n"



.text



matrix_mult:

    pushl %ebp             ;# salvam baza stivei

    mov %esp, %ebp         ;# setam baza stivei la pointer-ul curent din stiva



    ;# setam variabilele pentru for-uri de la dreapta la stanga, pentru simplitate cand folosesc gdb-ul

    movl 20(%ebp), %eax ;# n

    decl %eax              ;# decrementam n (icepem de la 0 numararea)

    movl %eax, %esi         ;# setam esi la n-1

    movl %eax, %edi         ;# setam edi la n-1

    xorl %ecx, %ecx         



row_loop:

    ;# verifica daca am fost in toate liniile

    cmp $0, %esi          ;# am intrat in toate liniile?

    jl end_row_loop      ;# if esi < 0, jump end_row_loop



    movl %eax, %edi         ;# reseteaza edi la n-1



    column_loop:

	    ;# verifica daca am fost in toate coloanele 

	    cmp $0, %edi       ;# am intrat in toate coloanele?

	    jl end_column_loop   ;# if edi < 0, jump end_column_loop



	    ;# calculeaza mres[esi][edi] = m1[esi][edi] * m2[edi][esi]

	    movl 12(%ebp), %ebx       ;# in ebx sa fie adresa lui m2

	    movl 8(%ebp), %edx        ;# in edx sa fie adresa lui m1

	    movl (%ebx, %edi, 4), %eax      ;# m2[edi][esi] 

	    mull (%edx, %esi, 4)         ;# m1[esi][edi] * m2[edi][esi]

	    addl %eax, %ecx                ;# tinem minte in ecx



	    decl %edi              ;# decremenreaza nr coloanei

	    jmp column_loop      ;# continua cu urmatoarea coloana



    end_column_loop:

    

    ;# tinem minte rezultatul in mres[esi][esi]

    movl $3, %eax

    movl 16(%ebp), %ebx     ;# get mres

    movl %eax, (%ebx, %esi, 4)         ;# tinem minte rezultatul in mres[esi][esi]



    xorl %ecx, %ecx         

    decl %esi              ;# decrementam nr de coloane

    jmp row_loop         ;# continua la linia urmatoare



end_row_loop:

    popl %ebp              ;# refacem base pointer-ul

    ret                  ;# returneaza in main din functie











.global main

main:



;# citim nr cerintei

pushl $c

pushl $cit

call scanf

popl %ebx

popl %ebx





;# citim nr de noduri

pushl $n

pushl $cit

call scanf

popl %ebx

popl %ebx



xorl %ecx, %ecx

lea vec, %edi



;# facem un for pentru cate legaturi avem

for_citire: 

    cmp n, %ecx

    je exit_for_citire



    pusha

    pushl $a

    pushl $cit

    call scanf

    popl %ebx

    popl %ebx

    popa



    movl a, %eax #punem numarul in a

    movl %eax, (%edi, %ecx, 4) #punem numarul a in vactor

    incl %ecx

    jmp for_citire

exit_for_citire:



xorl %ecx, %ecx

lea vec, %edi



;# citim valorile din fiecare elem din vector

for_i:

    cmp n, %ecx

    je afisare

    movl (%edi, %ecx, 4), %eax

    movl %eax, p

    xorl %ebx, %ebx

    

    for_j:

    	cmp p, %ebx

    	je continuare_for

    	

    	pusha

    	pushl $a

    	pushl $cit

    	call scanf

   	  popl %ebx

    	popl %ebx

    	popa

    	

    	;#implementam in matrice unde left-->%eax si right-->a    adica m1[%eax][a]

    	movl %ecx, %eax

    	movl $0, %edx       

	mull n

	addl a, %eax

	lea m1, %esi

	movl $1, (%esi, %eax, 4)		

	

	movl %ecx, %eax

  movl $0, %edx       

	mull n

	addl a, %eax

	lea m2, %esi

	movl $1, (%esi, %eax, 4)

	

    	incl %ebx

    	jmp for_j

    	

    continuare_for:

    incl %ecx

    jmp for_i



afisare:



;#alegem pe ce cerinta sa mearga

movl $2, %eax

cmp c, %eax

je cerinta_2



xorl %eax, %eax





;# afisarea matricei m1

movl $0, lineIndex

for_lines:

	movl lineIndex, %ecx

	cmp n, %ecx

	je exit

	movl $0, columnIndex

	

	for_columns:

		movl columnIndex, %ecx

		cmp n, %ecx

		je cont

		movl lineIndex, %eax

		movl $0, %edx

		mull n

		addl columnIndex, %eax

		lea m1, %esi

		movl (%esi, %eax, 4), %ebx

		pushl %ebx

		pushl $afismat

		call printf

		popl %ebx

		popl %ebx

		pushl $0

		call fflush

		popl %ebx

		incl columnIndex

		jmp for_columns

		

	cont:

	

	movl $4, %eax

	movl $1, %ebx

	movl $newLine, %ecx

	movl $2, %edx

	int $0x80

	

	incl lineIndex

	jmp for_lines









;#inceputul cerintei 2



cerinta_2:

 

xorl %eax, %eax



;# citim nr de inmultiri de matrice

pushl $k

pushl $cit

call scanf

popl %ebx

popl %ebx



;#citim primul nod din care vrem sa pornim

pushl $st

pushl $cit

call scanf

popl %ebx

popl %ebx



;#citim al doilea nod, cel in care vrem sa ajungem

pushl $dr

pushl $cit

call scanf

popl %ebx

popl %ebx



lea m1, %eax



lea m2, %ebx



lea mres, %ecx



chestie:



movl $1, %edx



for_drum:              ;# mres-->%ecx     m2-->%ebx    m1-->%eax

	cmp k, %edx

	je afi

	

	pusha

	pushl n

	pushl %ecx

	pushl %ebx

	pushl %eax

	call matrix_mult

	addl $16, %esp

	popa

	

	movl %ecx, %eax

	incl %edx

	jmp for_drum

	

afi:



;#implementam in matrice unde left-->st si right-->dr    adica mres[st][dr]

    	movl st, %eax

    	movl $0, %edx       

	mull n

	addl dr, %eax

	lea mres, %ecx

	movl (%ecx, %eax, 4), %edx

	

;# afisarea valorii cerute







pushl %edx

pushl $afis

call printf

popl %ebx

popl %ebx





;# afisarea matricei mres pt verificare

movl $0, lineIndex

for_liness:

	movl lineIndex, %ecx

	cmp n, %ecx

	je exit

	movl $0, columnIndex



	

	for_columnss:

		movl columnIndex, %ecx

		cmp n, %ecx

		je contt

		movl lineIndex, %eax

		movl $0, %edx

		mull n

		addl columnIndex, %eax

		lea mres, %ecx

		movl (%ecx, %eax, 4), %ebx

		pushl %ebx

	  pushl $afismat

		call printf

		popl %ebx

		popl %ebx

		pushl $0

		call fflush

		popl %ebx

		incl columnIndex

		jmp for_columnss



		

	contt:



	

	movl $4, %eax

	movl $1, %ebx

	movl $newLine, %ecx

	movl $2, %edx

	int $0x80



	incl lineIndex

	jmp for_liness





exit:	



movl $1, %eax

xorl %ebx, %ebx

int $0x80
