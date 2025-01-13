.data
   // Scanf,Printf,NewLine
   sf: .asciz "%d"
   pf: .asciz "%d "
   nl: .asciz "\n"
   m: .space 4 
   n: .space 4
   m2: .space 4 
   n2: .space 4
   m3: .space 4 
   n3: .space 4
   valoare_celula: .space 4
   index_celula: .space 4
   p: .space 4
   k: .space 4
   index: .space 4
   matrice: .space 1296
   matrice_extinsa : .space 1600
   matrice_copie: .space 1600
   lineIndex: .space 4
   columnIndex: .space 4    
   suma_vecini: .space 4
   
   // Valori pentru a stoca x-ul si y-ul celulelor vii
   cv_x: .space 4
   cv_y: .space 4
   
.text

.global main

main:
   // Citim m,n,p
   push $m
   push $sf
   call scanf
   add $8, %esp
   
   push $n
   push $sf
   call scanf
   add $8, %esp
   
   push $p
   push $sf
   call scanf
   add $8, %esp
   
   // Indexii matricii extinse
   movl m, %eax      
   addl $2, %eax    
   movl %eax, m2 
   
   movl n, %eax      
   addl $2, %eax    
   movl %eax, n2   
   
   movl m, %eax      
   addl $1, %eax    
   movl %eax, m3 
   
   movl n, %eax      
   addl $1, %eax    
   movl %eax, n3 

   
// Initializam matricea cu 0
initializare:
   movl $0, lineIndex
   for_lines:
      // Verificam daca lineIndex a ajuns la final
      movl lineIndex, %ecx
      cmp %ecx, m
      je adaugare_cv
      
      movl $0, columnIndex
   
      // Pt fiecare coloana
      for_columns:
         // Verificam daca columnIndex a ajuns la final
         movl columnIndex, %ecx
         cmp %ecx, n
         je cont_lines
      
         // %eax = n(nr coloane) * lineIndex + columnIndex
         movl lineIndex, %eax
         movl $0, %edx
         mull n
         addl columnIndex, %eax
      
         // Facem fiecare element din matrice 0
         lea matrice, %edi
         movl $0, (%edi, %eax, 4)
      
         // +1 columnIndex
         addl $1, columnIndex
         jmp for_columns
      
   cont_lines:
      // +1 lineIndex
      addl $1, lineIndex
      jmp for_lines

// Adaugam celulele vii
adaugare_cv:
   movl $0, index
   for_cv:
      mov index, %ecx
      cmp %ecx, p
      je initializare_matrice_extinsa
      
      push $cv_x
      push $sf
      call scanf
      add $8, %esp
      
      push $cv_y
      push $sf
      call scanf
      add $8, %esp
      
      movl cv_x, %eax
      movl $0, %edx
      mull n
      addl cv_y, %eax
      
      // Citim x-ul si y-ul aferent unei celule vii, si ii modificam valoarea
      lea matrice, %edi
      movl $1, (%edi, %eax, 4)
      
      addl $1, index
      jmp for_cv


initializare_matrice_extinsa:
   movl $0, lineIndex
   for_lines_e:
      // Verificam daca lineIndex a ajuns la final
      movl lineIndex, %ecx
      cmp %ecx, m2
      je completare_matrice_extinsa
   
      movl $0, columnIndex
   
      // Pt fiecare coloana
      for_columns_e:
         // Verificam daca columnIndex a ajuns la final
         movl columnIndex, %ecx
         cmp %ecx, n2
         je cont_lines_e
      
         // %eax = n(nr coloane) * lineIndex + columnIndex
         movl lineIndex, %eax
         movl $0, %edx
         mull n2
         addl columnIndex, %eax
      
         // Facem fiecare element din matrice 0
         lea matrice_extinsa, %edi
         movl $0, (%edi, %eax, 4)
         
         lea matrice_copie, %esi
         movl $0, (%esi, %eax, 4)
         
         // +1 columnIndex
         addl $1, columnIndex
         jmp for_columns_e
      
   cont_lines_e:
      // +1 lineIndex
      addl $1, lineIndex
      jmp for_lines_e
      
completare_matrice_extinsa:
   movl $0, lineIndex
   for_lines_ec:
      movl lineIndex, %ecx
      cmp %ecx, m
      je evolutie
      
      movl $0, columnIndex
      
      for_columns_ec:
         movl columnIndex, %ecx
         cmp %ecx, n
         je cont_lines_ec
         
         movl lineIndex, %eax
         movl $0, %edx
         mull n
         addl columnIndex, %eax
         // Stocam elementul din matricea initiala in %ebx
         lea matrice, %edi
         movl (%edi, %eax, 4), %ebx
         
         
         // Punem elementul din matricea initiala, in cea extinsa, pe pozitia corespunzatoare
         movl lineIndex, %eax
         addl $1, %eax
         movl $0, %edx
         mull n2
         addl columnIndex, %eax
         addl $1, %eax
                
         lea matrice_extinsa, %edi
         movl %ebx, (%edi, %eax, 4)
         
         lea matrice_copie, %esi
         movl %ebx, (%esi, %eax, 4)
         
         addl $1, columnIndex
         jmp for_columns_ec
         
         
      cont_lines_ec:
         addl $1, lineIndex
         jmp for_lines_ec 
      
      
evolutie:
   push $k
   push $sf
   call scanf
   add $8, %esp
   
   movl $0, index
   for_k:
      movl index, %ecx
      cmp %ecx, k
      je afisare
      
      movl $1, lineIndex
      for_lines_evo:
         movl lineIndex, %ecx
         cmp %ecx, m3
         je copiere
         
         
         movl $1, columnIndex
         for_columns_evo:
            movl $0, suma_vecini
            movl columnIndex, %ecx
            cmp %ecx, n3
            je evo_cont
            
            movl lineIndex, %eax
            movl $0, %edx
            mull n2
            addl columnIndex, %eax
            lea matrice_extinsa, %edi
            lea matrice_copie, %esi
            movl (%edi, %eax, 4), %ebx
            
            // Stocam valoarea celulei(0 sau 1) 
            mov %ebx, valoare_celula
            
            // Luam fiecare vecin in parte si le adunam valorile(cati vecini sunt vii)
            
            // Vecin stanga
            subl $1, %eax
            movl (%edi, %eax, 4), %ebx
            addl %ebx, suma_vecini
            addl $1, %eax
            
            // Vecin dreapta
            addl $1, %eax
            movl (%edi, %eax, 4), %ebx
            addl %ebx, suma_vecini
            subl $1, %eax
            
            // Vecin sus
            subl n2, %eax
            movl (%edi, %eax, 4), %ebx
            addl %ebx, suma_vecini
            addl n2, %eax
            
            // Vecin jos
            addl n2, %eax
            movl (%edi, %eax, 4), %ebx
            addl %ebx, suma_vecini
            subl n2, %eax
            
            // Vecin stanga + sus
            subl n2, %eax
            subl $1, %eax
            movl (%edi, %eax, 4), %ebx
            addl %ebx, suma_vecini
            addl n2, %eax
            addl $1, %eax
            
            // Vecin dreapta + sus
            subl n2, %eax
            addl $1, %eax
            movl (%edi, %eax, 4), %ebx
            addl %ebx, suma_vecini
            addl n2, %eax
            subl $1, %eax
            
            // Vecin stanga + jos
            addl n2, %eax
            subl $1, %eax
            movl (%edi, %eax, 4), %ebx
            addl %ebx, suma_vecini
            subl n2, %eax
            addl $1, %eax
            
            // Vecin dreapta + jos
            addl n2, %eax
            addl $1, %eax
            movl (%edi, %eax, 4), %ebx
            addl %ebx, suma_vecini
            subl n2, %eax
            subl $1, %eax
            
            movl valoare_celula, %ecx
            
            // Verificam valoarea celulei, si in functie de asta ne ghidam
            cmp $1, %ecx
            je celula_vie
            jne celula_moarta
            
            
            celula_vie:
               movl suma_vecini, %ecx
               cmp $2, %ecx
               je modificare_v
               cmp $3, %ecx
               je modificare_v
               jmp modificare_v_m
               
               modificare_v:
                  lea matrice_copie, %esi
                  movl $1, (%esi, %eax, 4)
                  jmp continuare
                  
               modificare_v_m:
                  lea matrice_copie, %esi
                  movl $0, (%esi, %eax, 4)
                  jmp continuare
               
               
             celula_moarta:
               movl suma_vecini, %ecx
               cmp $3, %ecx
               je modificare_m
               jmp continuare
               
               modificare_m:
                  lea matrice_copie, %esi
                  movl $1, (%esi, %eax, 4)
                  jmp continuare
                  
              continuare:
                 addl $1, columnIndex
                 jmp for_columns_evo 
          evo_cont:
             addl $1, lineIndex
             jmp for_lines_evo
          
      
   copiere:
         movl $1, lineIndex
         for_cpy_l:
            movl lineIndex, %ecx
            cmp %ecx, m3
            je cont_k
            
            movl $1, columnIndex
            for_cpy_c:
               movl columnIndex, %ecx
               cmp %ecx, n3
               je cpy_cont
               
               movl lineIndex, %eax
               movl $0, %edx
               mull n2
               addl columnIndex, %eax
               
               lea matrice_extinsa, %edi
               lea matrice_copie, %esi
               movl (%esi, %eax, 4), %ebx
               movl %ebx, (%edi, %eax, 4)
               
               addl $1,columnIndex
               jmp for_cpy_c
               
               
            
         cpy_cont:
            addl $1, lineIndex
            jmp for_cpy_l
                  
      cont_k:
         addl $1, index
         jmp for_k
     
         


// Afisam matricea
afisare:
   movl $1, lineIndex
   afis_linie:
      movl lineIndex, %ecx
      cmp %ecx, m3
      je exit
      
      movl $1, columnIndex
      afis_coloane:
         movl columnIndex, %ecx
         cmp %ecx, n3
         je afis_cont
        
         
         movl lineIndex, %eax
         movl $0, %edx
         mull n2
         addl columnIndex, %eax
      
         lea matrice_extinsa, %edi
         movl (%edi, %eax, 4), %ebx
         
         push %ebx
         push $pf
         call printf
         add $8, %esp
         
         push $0 
         call fflush
         add $8, %esp
         
         addl $1, columnIndex
         jmp afis_coloane
         
   afis_cont:
      movl $4, %eax
      movl $1 , %ebx
      movl $nl, %ecx
      movl $2, %edx
      int $0x80
       
      addl $1, lineIndex
      jmp afis_linie
   	
     	
exit:
   mov $1, %eax
   mov $0, %ebx
   int $0x80
