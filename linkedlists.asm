.386
.model flat, stdcall

includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern puts: proc
extern scanf: proc
extern strcmp:proc
extern strncmp:proc
extern fscanf:proc
extern fprintf:proc
extern fopen:proc
extern fclose:proc
extern gets: proc
extern malloc: proc
extern free:proc
public start

.data
caracter DB '%c',0
mesaj1 DB "creare lista ",0
mesaj2 DB "in [numar]",0
mesaj3 DB "stergere [numar] ",0
mesaj4 DB "afisare ",0
mesaj5 DB "save lista ",0
mesaj6 DB "load lista ",0
mesaj7 DB "exit ",0
;bucla de selectie
functie1 db "creare lista",0
functie2 db "in ",0
functie3 db "stergere ",0 ;stergere
functie4 db "afisare",0
functie5 db "save lista",0
functie6 db "load lista",0
functie7 db "exit",0

sir db 20 dup(0),0
format db "%s ",0
eroare db "Comanda necunoscuta",0
;creare
creator db 0
;inserare
contor db 0
aux dd 0
aux2 db 0
minus db 0
format2 db "%d ",0
prim dd 0
ultim dd 0
p dd 0

;afisare
mesaj_eroare1 db "Lista nu a fost creata",0
mesaj_eroare2 db "Lista nu contine nici un numar",0

;stergere
mesaj_eroare3 db "Index inexistent",0
aux3 dd 0
;scriere in fisier
fisier db "lista.txt",0
mode_w db "w",0
f dd 0

;citire din fisier
mode_r db "r",0
format3 db "%d",0
mesaj_eroare4 db "Fisier inexistent",0

.code
creare_lista proc
	push ebp
	mov ebp, esp
	mov creator,1
	mov esp, ebp
	pop ebp
	ret
creare_lista endp

inserare_lista proc
	push ebp
	mov ebp, esp
	mov ecx,0
	cmp ecx,prim
	jne inserare
		
	mov ecx,8
	push ecx
	call malloc
	add esp,4
		
	mov esi,eax
	mov prim, esi
	mov ultim, esi
	mov ebx, aux
	mov dword ptr [esi],  ebx	
			
	mov ecx,0
	mov cl,1
	mov contor,cl
		
	add esi,4
	mov ecx,0
	mov dword ptr [esi],ecx
	
	mov esp, ebp
	pop ebp
	ret
		
	inserare:
		
		
	mov ecx,8
	push ecx
	call malloc
	add esp,4
	mov esi,ultim
	add esi,4
	mov dword ptr [esi], eax
	mov esi,eax
	mov edx,aux
	mov dword ptr [esi], edx 
	mov ultim,esi

	mov ecx,0
	mov cl,contor
	inc cl
	mov contor,cl
		
	add esi,4
	mov ecx,0
	mov dword ptr [esi], ecx

	mov esp, ebp
	pop ebp
	ret
inserare_lista endp

stergere_lista proc
	push ebp
	mov ebp, esp
	
	mov eax,aux
	mov ebx,0
	mov bl,contor
	cmp eax,ebx
	jg test3
	mov eax,aux
	cmp eax,0
	jle test3
	mov eax,aux
	cmp eax,1
	jne verificare_ultim
	mov eax,1
	mov ebx,0
	mov bl,contor
	cmp eax,ebx
	jne stergere_normala
	;aici sterge daca este un singur element
	mov esi,prim
	call free
	mov prim,0
	mov ultim,0
	mov contor,0
	jmp bucla
	
	verificare_ultim:
		mov ebx,0
		mov bl,contor
		mov eax,aux
		cmp eax,ebx
		jne stergere_normala
		;aici sterge daca e ultimul element
		mov ecx,0
		mov edx,1
		mov cl,contor
		sub cl,1
		mov esi,prim
		b_st:	
			cmp edx,ecx
			je gasit_penultim
			add esi,4
			mov eax,dword ptr [esi]
			mov esi, eax
			add edx,1
			jmp b_st
		gasit_penultim:
		mov ultim,esi
		add esi,4
		mov eax, dword ptr [esi]
		mov dword ptr [esi],0
		mov esi,eax
		call free
		mov eax,0
		mov al,contor
		sub eax,1
		mov contor,al
		
		mov esp, ebp
		pop ebp
		ret
	stergere_normala:
		;aici e stergerea normala 
		mov ecx,0
		mov edx,1
		mov ecx,aux
		cmp ecx,1
		je stergere1_2
		sub ecx,1
		mov esi,prim
		b_st2:	
			cmp edx,ecx
			je gasit_index
			add esi,4
			mov eax,dword ptr [esi]
			mov esi, eax
			add edx,1
			jmp b_st2
		gasit_index:
		
		mov ebx,esi
		add esi,4
		mov eax,dword ptr [esi]
		mov esi,eax
		add esi,4
		mov eax,dword ptr [esi]
		mov p,eax
		sub esi,4
		call free
		mov esi,ebx
		add esi,4
		mov eax,p
		mov dword ptr [esi],eax
		mov eax,0
		mov al,contor
		sub eax,1
		mov contor,al
		mov esp, ebp
		pop ebp
		ret
		
	stergere1_2:
		mov esi,prim
		add esi,4
		mov eax, dword ptr [esi]
		mov prim,eax
		sub esi,4
		call free
		mov al,contor
		sub eax,1
		mov contor,al
		mov esp, ebp
		pop ebp
		ret
		
	test3:
			push offset mesaj_eroare3
			call puts
			add esp,4
			mov esp, ebp
			pop ebp
			ret

stergere_lista endp
afisare_lista proc
	push ebp
	mov ebp, esp
	
	mov eax,0
		mov al,creator
		cmp al,1
		jne test1
		
		mov eax,0
		mov al,contor
		cmp al,0
		je test2
		
		mov edx,prim
		
	afis:
		mov esi,edx
		push dword ptr [esi]
		push offset format2
		call printf
		add esp,8
	
		add esi,4
		mov ebx,dword ptr [esi]
		cmp ebx,0
		je ies_afis
		mov edx,ebx
		jmp afis
	ies_afis:
		mov eax, 10
	push eax
	push offset caracter
	call printf
	add esp,8
	mov esp, ebp
	pop ebp
	ret
		
	test1:
		push offset mesaj_eroare1
		call puts
		add esp,4
		mov esp, ebp
		pop ebp
		ret
		
	test2:
		push offset mesaj_eroare2
		call puts
		add esp,4
		mov esp, ebp
		pop ebp
		ret
	
afisare_lista endp

salvare_lista proc
	push ebp
	mov ebp, esp
	mov eax,0
	mov al,creator
	cmp al,1
	jne test1
	
	mov eax,0
	mov al,contor
	cmp al,0
	je test2
	
	push offset mode_w
	push offset fisier
	call fopen
	add esp,8
	mov f,eax
	
	mov edx,prim
		
	afis2:
	mov esi,edx
	push dword ptr [esi]
	push offset format2
	push f
	call fprintf
	add esp,12

	add esi,4
	mov ebx,dword ptr [esi]
	cmp ebx,0
	je ies_afis2
	mov edx,ebx
	jmp afis2
ies_afis2:
	mov esi,f
	push esi
	call fclose
	mov esi,prim
	dealoc2:
		add esi,4
		mov ebx,dword ptr [esi]
		sub esi,4
		call free
		cmp ebx,0
		je iesi2
			mov esi,ebx
		jmp dealoc2
	iesi2:
	mov prim,0
	mov ultim,0
	mov creator,0
	mov contor,0
		
	mov esp, ebp
		pop ebp
		ret

	test1:
		push offset mesaj_eroare1
		call puts
		add esp,4
		mov esp, ebp
		pop ebp
		ret
		
	test2:
		push offset mesaj_eroare2
		call puts
		add esp,4
		mov esp, ebp
		pop ebp
		ret
		
salvare_lista endp

incarca_lista proc
	push ebp
	mov ebp, esp
	push offset mode_r
	push offset fisier
	call fopen
	add esp,8
	mov f,eax
	mov ecx,0
	cmp eax,ecx
	je eroare_fisier
	mov creator,1
		
	citire_bucla:
		push offset aux
		push offset format2
		push f
		call fscanf
		add esp,12
		cmp eax,-1
		je inchidere_fisier
		
		mov ecx,0
		cmp ecx,prim
		jne inserare2
		
		mov ecx,8
		push ecx
		call malloc
		add esp,4
		
		mov esi,eax
		mov prim, esi
		mov ultim, esi
		mov ebx, aux
		mov dword ptr [esi],  ebx	
			
		mov ecx,0
		mov cl,1
		mov contor,cl
		
		add esi,4
		mov ecx,0
		mov dword ptr [esi],ecx
		jmp citire_bucla
		
		inserare2:
		mov ecx,8
		push ecx
		call malloc
		add esp,4
		mov esi,ultim
		add esi,4
		mov dword ptr [esi], eax
		mov esi,eax
		mov edx,aux
		mov dword ptr [esi], edx 
		mov ultim,esi
		
		mov ecx,0
		mov cl,contor
		inc cl
		mov contor,cl
		
		add esi,4
		mov ecx,0
		mov dword ptr [esi], ecx
		
		jmp citire_bucla
		
	inchidere_fisier:
		
		push f
		call fclose
		add esp, 4
		mov esp, ebp
		pop ebp
		ret
	eroare_fisier:
			push offset mesaj_eroare4
			call puts
			add esp,4
			mov esp, ebp
			pop ebp
			ret
			
incarca_lista endp

iesire_program proc
	push ebp
	mov ebp, esp
	mov eax,0
	mov al,creator
	cmp eax,0
	je iesi1
	mov eax,0
	mov al,contor
	cmp eax,0
	je iesi1
	mov esi,prim
	dealoc:
	add esi,4
	mov ebx,dword ptr [esi]
	sub esi,4
	call free
	cmp ebx,0
	je iesi1
	mov esi,ebx
	jmp dealoc
	iesi1:
	push 0
	call exit
iesire_program endp
	
start:
	mov creator,0
	mov contor,0
	push offset mesaj1
	call printf
	add esp,4
	mov eax, 10
	push eax
	push offset caracter
	call printf
	add esp,4
	
	push offset mesaj2
	call printf
	add esp,4
	mov eax, 10
	push eax
	push offset caracter
	call printf
	add esp,4
	
	push offset mesaj3
	call printf
	add esp,4
	mov eax, 10
	push eax
	push offset caracter
	call printf
	add esp,4
	
	push offset mesaj4
	call printf
	add esp,4
	mov eax, 10
	push eax
	push offset caracter
	call printf
	add esp,4
	
	push offset mesaj5
	call printf
	add esp,4
	mov eax, 10
	push eax
	push offset caracter
	call printf
	add esp,4
	
	push offset mesaj6
	call printf
	add esp,4
	mov eax, 10
	push eax
	push offset caracter
	call printf
	add esp,4
	
	push offset mesaj7
	call printf
	add esp,4
	mov eax, 10
	push eax
	push offset caracter
	call printf
	add esp,4
	
bucla:
		push offset sir
		call gets
		add esp,4
		lea esi,sir
		
		push offset sir
		push offset functie1
		call strcmp
		add esp,8
		cmp eax,0
		je creare
		
		push offset 3
		push offset sir
		push offset functie2
		call strncmp
		add esp,12
		cmp eax,0
		je introducere
		
		push offset 9
		push offset sir
		push offset functie3
		call strncmp
		add esp,12
		cmp eax,0
		je sterge
		
		push offset sir
		push offset functie4
		call strcmp
		add esp,8
		cmp eax,0
		je afisare
		
		
		push offset sir
		push offset functie5
		call strcmp
		add esp,8
		cmp eax,0
		je salvare
		
		push offset sir
		push offset functie6
		call strcmp
		add esp,8
		cmp eax,0
		je incarca
		
		push offset sir
		push offset functie7
		call strcmp
		add esp,8
		cmp eax,0
		je iesire
		
		push offset eroare
		call puts
		add esp,4
		
		jmp bucla
		
creare:
		call creare_lista
		jmp bucla
		
introducere:
		mov eax,0
		mov al,creator
		cmp al,1
		jne test1

		mov minus,0
		
		add esi,3
		
		mov ecx,0
		mov edx,0
		mov ebx,0
		mov aux,0
		
		mov cl,[esi]  ;verifica cu minus
		mov dl,45
		cmp dl,cl
		jne ne_neg
		mov minus,1
		inc esi
		ne_neg:
			
		transformare:
			mov ebx,0
			mov eax,0
			mov bl,[esi]			
			mov aux2,bl						
			cmp ebx,0
			je iesire_transf
			
			mov dl,48
			sub bl,dl					
			mov eax,aux
			mov ecx,10
			mul ecx
			
			add eax,ebx
			mov aux,eax
			inc esi	
			jmp transformare
		
		iesire_transf:
		
			mov eax,aux
			mov ebx,0
			cmp bl,minus
			je gata_procesat
			neg eax
		gata_procesat:
		mov aux, eax
		call inserare_lista
		jmp bucla
		
sterge:
		mov eax,0
		mov al,creator
		cmp al,1
		jne test1
		
		mov eax,0
		mov al,contor
		cmp al,0
		je test2
		
		add esi,9
		mov aux,0
		transformare2:
			mov ebx,0
			mov eax,0
			mov bl,[esi]			
			mov aux2,bl						
			cmp ebx,0
			je iesire_transf2
			
			mov dl,48
			sub bl,dl					
			mov eax,aux
			mov ecx,10
			mul ecx
			
			add eax,ebx
			mov aux,eax
			inc esi	
			jmp transformare2	
		iesire_transf2:
		call stergere_lista
		jmp bucla
		
afisare:
	call afisare_lista
	jmp bucla
	
	test1:
		push offset mesaj_eroare1
		call puts
		add esp,4
		jmp bucla
		
	test2:
		push offset mesaj_eroare2
		call puts
		add esp,4
		jmp bucla
		
salvare:
		call salvare_lista
		jmp bucla
		
incarca:
		call incarca_lista
		jmp bucla
		
iesire:
		call iesire_program
		
end start