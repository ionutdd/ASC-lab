
		.data







c: .space 4



n: .space 4



a: .space 4



p: .space 4



k: .space 4



garbage1: .space 4



garbage2: .space 4



garbage3: .space 4



garbage4: .space 4



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



    movl %esi, 24(%ebp)  











all_loop:



	movl 24(%ebp), %ecx



	cmp $0, %ecx



	jl end_all_loop



	xorl %ecx, %ecx



	movl 20(%ebp), %eax 



    	decl %eax



	movl %eax, %esi         



        movl %eax, %edi



    



	row_loop:



	    ;# verifica daca am fost in toate liniile



	    cmp $0, %esi          ;# am intrat in toate liniile?



	    jl end_row_loop      ;# if esi < 0, jump end_row_loop







	    movl %eax, %edi         ;# reseteaza edi la n-1



	    movl %esi, 28(%ebp)



	    



	    column_loop:



		    ;# verifica daca am fost in toate coloanele 



		    cmp $0, %edi       ;# am intrat in toate coloanele?



		    jl end_column_loop   ;# if edi < 0, jump end_column_loop







		    ;# calculeaza mres[esi][edi] = m1[esi][edi] * m2[edi][esi]



		    movl 12(%ebp), %ebx       ;# in ebx sa fie adresa lui m2



		    movl 8(%ebp), %ecx        ;# in ecx sa fie adresa lui m1



		    



		    movl 28(%ebp), %esi



		    movl %edi, %eax



	    	    movl $0, %edx       



		    mull 20(%ebp)



		    addl %esi, %eax



		    



		    movl (%ebx, %eax, 4), %ebx      ;# m2[edi][esi] 



		    



		    



		    movl 24(%ebp), %eax



	    	    movl $0, %edx       



		    mull 20(%ebp)



		    addl %edi, %eax



		    movl %eax, %esi



		    



		    movl %ebx, %eax



		    movl $0, %edx   



		    mull (%ecx, %esi, 4)         ;# m1[24(%ebp)][edi] * m2[edi][esi]



		    subl %edi, %esi



		    movl %eax, %ebx



		    movl %esi, %eax



		    movl $0, %edx



		    divl 20(%ebp)



		    movl %eax, %esi



		    movl %ebx, %eax



		    



		    movl 16(%ebp), %ebx     ;# get mres



		    movl %eax, %ecx



		    movl 24(%ebp), %eax



		    movl $0, %edx



		    mull 20(%ebp)



		    movl 28(%ebp), %esi



		    addl %esi, %eax



		    movl %eax, %esi



		    movl %ecx, %eax



		    addl %eax, (%ebx, %esi, 4)         ;# tinem minte rezultatul in mres[24(%ebp)][esi]



		    movl 20(%ebp), %eax



		    movl 28(%ebp), %esi



		    



		    decl %edi              ;# decremenreaza nr coloanei



		    jmp column_loop      ;# continua cu urmatoarea coloana







		   



		     











	    end_column_loop:



	    



	    



	    decl %esi              ;# decrementam nr de coloane



	    movl 20(%ebp), %eax



	    decl %eax



	    movl %esi, 28(%ebp)



	    jmp row_loop         ;# continua la linia urmatoare







	end_row_loop:



	



	movl 24(%ebp), %ecx



	decl %ecx



	movl %ecx, 24(%ebp)



	xorl %ecx, %ecx



	jmp all_loop



	



	



	



end_all_loop:



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



	pusha	



	movl $4, %eax



	movl $1, %ebx



	movl $newLine, %ecx



	movl $2, %edx



	popa

	

	int $0x80

	

	pushl $0



	call fflush



	popl %ebx



	



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







;# daca k=1







movl $1, %edx



cmp k, %edx



je affi







for_drum:              ;# mres-->%ecx     m2-->%ebx    m1-->%eax



	cmp k, %edx



	je afi



	



	;# trebuie initializat mres cu 0



	



	movl %edx, garbage1  ;# salvam %eax si %edx pentru ca ii "stricam" si avem nevoie de ei intacti dupa



	movl %eax, garbage2



	xorl %edi, %edi



	movl %edi, garbage3



	



	init_0_row:



		cmp n, %edi



		je end_init_0_row



		



		xorl %esi, %esi



		



		init_0_column:



			cmp n, %esi



			je end_init_0_column



			



			movl %edi, %eax



			movl $0, %edx



			mull n



			addl %esi, %eax



			movl $0, (%ecx, %eax, 4)    ;# mres[%edi][%esi]=0



			



			incl %esi



			jmp init_0_column



		



		end_init_0_column:



		



		incl %edi



		jmp init_0_row



			



	end_init_0_row:



	



	



	movl garbage2, %eax



	



	pusha



	pushl n



	pushl %ecx



	pushl %ebx



	pushl %eax



	call matrix_mult



	addl $16, %esp



	popa



	



	;# incarcam in m1, care este la adresa %eax, tot ce este in mres, care este la adresa %ecx



	



	xorl %edi, %edi



	for_copy_row:



		cmp n, %edi



		je end_for_copy_row



		



		xorl %esi, %esi



		



		for_copy_column:



			cmp n, %esi



			je end_for_copy_column



			



			xorl %edx, %edx



			movl %edx, garbage3



			for_imul:



				cmp n, %edx



				je end_for_imul



				



				addl %edi, garbage3



				incl %edx



				jmp for_imul



			



			end_for_imul:



			



			addl %esi, garbage3



			movl %esi, garbage4



			movl garbage3, %edx



			movl (%ecx, %edx, 4), %esi



			movl %esi, (%eax, %edx, 4)



			movl garbage4, %esi



			incl %esi



			jmp for_copy_column



		



		end_for_copy_column:



		



		incl %edi



		jmp for_copy_row



			



	end_for_copy_row:



	



	movl garbage1, %edx



	movl garbage2, %eax



	incl %edx



	jmp for_drum



	



affi:   ;# cazul in care k=1







movl %eax, %ecx







;#implementam in matrice unde left-->st si right-->dr    adica mres[st][dr]



    	movl st, %eax



    	movl $0, %edx       



	mull n



	addl dr, %eax



	movl (%ecx, %eax, 4), %edx



	



;# afisarea valorii cerute







pushl %edx



pushl $afis



call printf



popl %ebx



popl %ebx



pushl $0



call fflush



popl %ebx



jmp exit	



	



afi:







;#implementam in matrice unde left-->st si right-->dr    adica mres[st][dr]



    	movl st, %eax



    	movl $0, %edx       



	mull n



	addl dr, %eax



	movl (%ecx, %eax, 4), %edx



	



;# afisarea valorii cerute







pushl %edx



pushl $afis



call printf



popl %ebx



popl %ebx



pushl $0



call fflush



popl %ebx







exit:	







movl $1, %eax



xorl %ebx, %ebx



int $0x80
