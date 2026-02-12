 program p3

! Este programa se puede correr para las diferentes precisiones y cambiar nombres a
!  mano para hacer diferentes gráficos

 use ISOprec
 use funciones
 use derivadas1

 implicit none

 real(kind=wp)                               ::  h, em
 real(kind=wp),   dimension (3)              ::  x, ffpexact, gpexact

 integer   ::  k, m, i, fu1, fu2, fu3 

!------------------------------------------------------------------------


! -----------------------------------------------------------------------

write (*,*)  "    "

write (*,*) "precision(usada) wp  = " , wp

x(1) = 0.1_wp
x(2) = 1._wp
x(3) = 100._wp

write (*,*)  "    "
! Calculamos el epsilon de la 'máquina para las distintas precisiones'
write (*,*) " Epsilon de la maquina para las distintas precisiones"

write (*,*)  "    "

em = epsilon (1.0_rs )
write (*,*) " simple em=", em

em = epsilon (1.0_rd )
write (*,*) " doble  em=", em

em = epsilon (1.0_wp )
write (*,*) " large  em=", em

write (*,*)  "    "

do i =1 ,3
  write (* ,'(A,I2,A,I1,A,e10.3)') " h óptimo para derivada orden 2 = (3._wp * epsilon (x(",i ,&
                                          "))/ ( exp(x( ",i ," )))**(1._wp/3._wp) =" ,&
                                    ((3._wp * epsilon(x(i))/exp(x(i)))**(1._wp/3._wp ))
enddo

write (*,*)  "    "
write (*,*)

do i =1 ,3
   write (* , '(A , I2 ,A , I1 ,A , e10.3) ') " h óptimo para derivada orden 2 = (3._wp * epsilon (x(",i ,&
                           "))/(abs(cos(x(",i,"))))**(1._wp/3._wp) =" ,&
                         ((3._wp * epsilon(x(i))/abs(cos(x(i))))**(1._wp/3._wp))
enddo



write (*,*)


! ---------------------------------------------------------------------------------------------------------
! Estos valores se usarán frecuentemente, por lo que es más eficiente
! evaluarlos una sola vez y guardarlos con un nombre reusable.

do i =1 ,3
  ffpexact(i) = ffprima_exacta(x(i))
  gpexact(i) = gprima_exacta(x(i))
enddo

! ---------------------------------------------------------------------------------------------------------


open (newunit=fu1 , file = 'datos/p3-exp-1.dat' , status = 'replace')
open (newunit=fu2 , file = 'datos/p3-exp-2.dat' , status = 'replace')
open (newunit=fu3 , file = 'datos/p3-exp-3.dat' , status = 'replace')

write (fu1 , '(A ,5x ,A ,22 x ,6( A17 ,9 x) ) ') "# " ,"h" ," d1_o1(x(1) ,h ,f )" ," error relati 01 " , &
                          " d1_o2(x (1) ,h , f)" ," error relati 02 " , &
                          " d1_o4(x (1) ,h , f)" ," error relati 04 "

write (fu2 , '(A ,5x ,A ,22 x ,6( A17 ,9 x) ) ') "# " ,"h" ," d1_o1 (x(2) ,h ,f )" ," error relati 01 " , &
                           " d1_o2(x (2) ,h , f)" ," error relati 02 " , &
                           " d1_o4(x (2) ,h , f)" ," error relati 04"

write (fu3 , '(A ,5x ,A ,22 x ,6( A17 ,9 x) ) ') "# " ,"h" ," d1_o1 (x (3) ,h ,f )" ," error relati 01 " , &
                                " d1_o2(x (3) ,h , f)" ," error relati 02 " , &
                                " d1_o4(x (3) ,h , f)" ," error relati 04 "


 m = 30

do k = 1,m
   h = 10._wp**(-k)
   if (h < em ) exit

   write (fu1,*) h , d1_o1(x(1) ,h ,ff) , (ffpexact(1)-d1_o1(x(1) ,h , ff))/ffpexact(1) , &
                    d1_o2(x(1) ,h ,ff) , (ffpexact(1)-d1_o2(x(1), h , ff))/ffpexact (1) , &
                    d1_o4 (x(1) ,h ,ff) , (ffpexact(1)-d1_o4(x(1), h , ff))/ffpexact (1)

   write (fu2,*) h , d1_o1 (x(2),h ,ff) , (ffpexact(2)-d1_o1(x(2) ,h , ff))/ffpexact(2) , &
                    d1_o2 (x(2) ,h ,ff) , (ffpexact (2)-d1_o2(x(2), h , ff))/ffpexact (2) , &
                    d1_o4 (x(2) ,h ,ff) , (ffpexact (2)-d1_o4(x(2), h , ff))/ffpexact (2)


   write (fu3,*) h , d1_o1 (x(3) ,h ,ff) , (ffpexact(3)-d1_o1(x(3), h , ff))/ffpexact(3) , &
                    d1_o2 (x(3) ,h ,ff) , (ffpexact(3)-d1_o2(x(3), h , ff))/ffpexact (3) , &
                    d1_o4 (x(3) ,h ,ff) , (ffpexact(3)-d1_o4(x(3), h , ff))/ffpexact (3)

 !  write (*,*) h , d1_o1(x(1) ,h , ff) , (ffpexact(1)-d1_o1(x(1) ,h ,ff))/ffpexact(1) , &
 !  d1_o2 (x(1) ,h ,ff) , (ffpexact (1) - d1_o2(x(1) ,h ,ff ))/ffpexact (1) , &
 !  d1_o4 (x(1) ,h ,ff) , (ffpexact (1) - d1_o4(x(1) ,h ,ff ))/ffpexact (1)


 !  write (*,*) h , d1_o1(x(2) ,h , ff) , (ffpexact(2)-d1_o1(x(2) ,h ,ff))/ffpexact(2) , &
 !  d1_o2(x(2) ,h ,ff) , (ffpexact (2) - d1_o2(x (2) ,h ,ff ))/ffpexact (2) , &
 !  d1_o4(x(2) ,h ,ff) , (ffpexact (2) - d1_o4(x (2) ,h ,ff ))/ffpexact (2)

 !  write (*,*) h , d1_o1(x(3) ,h , ff) , (ffpexact(3)-d1_o1(x (3) ,h ,ff))/ffpexact(3) , &
 !  d1_o2(x (3) ,h ,ff) , (ffpexact (3) - d1_o2(x (3) ,h ,ff ))/ffpexact (3) , &
 !  d1_o4(x (3) ,h ,ff) , (ffpexact (3) - d1_o4(x (3) ,h ,ff ))/ffpexact (3)

end do

close(fu1)
close(fu2)
close(fu3)


!---------------------------------------------------------------------------------------------------

open (newunit=fu1 , file = 'datos/p3-cos-1.dat' , status = 'replace')
open (newunit=fu2 , file = 'datos/p3-cos-2.dat' , status = 'replace')
open (newunit=fu3 , file = 'datos/p3-cos-3.dat' , status = 'replace')
write (*,*)

write (fu1, '(A ,5x ,A ,22 x ,6( A17,9 x))') "# " ,"h" , " d1_o1 (x (1) ,h ,ff )" ," error relati 01 " , &
                                                            " d1_o2 (x (1) ,h , ff)" ," error relati 02 " ,  &
                                                            " d1_o4 (x (1) ,h , ff)" ," error relati 04 "

write (fu2, '(A ,5x ,A ,22 x ,6( A17,9 x))') "# " ,"h", " d1_o1 (x (2) ,h , ff)" ," error relati 01 " , &
                                                            " d1_o2 (x (2) ,h , ff)" ," error relati 02 " , &
                                                            " d1_o4 (x (2) ,h , ff)" ," error relati 04 "

write (fu3, '(A ,5x ,A ,22 x ,6( A17 ,9 x))') "# " ,"h" ," d1_o1 (x (3) ,h ,ff )" ," error relati 01 " , &
                                                            " d1_o2 (x(3) ,h , ff)" ," error relati 02 " ,  &
                                                            " d1_o4 (x(3) ,h , ff)" ," error relati 04 "



m = 30

 do k = 1,m
     h = 10._wp**(-k)
     if (h < em ) exit
     write (fu1 ,*) h, d1_o1(x(1) ,h ,g) , (gpexact(1)-d1_o1(x(1) ,h , g))/ gpexact(1) , &
                       d1_o2(x(1) ,h ,g) , (gpexact(1)-d1_o2(x(1) ,h , g))/ gpexact(1) , &
                       d1_o4(x(1) ,h ,g) , (gpexact(1)-d1_o4(x(1) ,h , g))/ gpexact(1)


     write (fu2 ,*) h, d1_o1(x(2) ,h ,g) , (gpexact(2)-d1_o1(x(2) ,h , g))/ gpexact(2) , &
                       d1_o2(x(2) ,h ,g) , (gpexact(2)-d1_o2(x(2) ,h , g))/ gpexact(2) , &
                       d1_o4(x(2) ,h ,g) , (gpexact(2)-d1_o4(x(2) ,h , g))/ gpexact(2)

     write (fu3 ,*) h, d1_o1(x(3) ,h ,g) , (gpexact(3)-d1_o1(x(3) ,h , g))/ gpexact(3) , &
                       d1_o2(x(3) ,h ,g) , (gpexact(3)-d1_o2(x(3) ,h , g))/ gpexact(3) , &
                       d1_o4(x(3) ,h ,g) , (gpexact(3)-d1_o4(x(3) ,h , g))/ gpexact(3)


 !    write (*,*) h, d1_o1(x(1) ,h , g) , (gpexact(1)-d1_o1 (x(1) ,h ,g))/gpexact(1) , &
 !                    d1_o2(x(1) ,h , g) , (gpexact(1)-d1_o2 (x(1) ,h ,g))/gpexact(1) , &
 !                    d1_o4(x(1) ,h , g) , (gpexact(1)-d1_o4 (x(1) ,h ,g))/gpexact(1)



 !     write (*,*) h, d1_o1(x(2) ,h , g) , ( gpexact (2) - d1_o1 (x (2) ,h ,g)) / gpexact (2) , &
 !                     d1_o2(x(2) ,h ,g) , ( gpexact (2) - d1_o2 (x (2) ,h ,g ))/ gpexact (2) , &
 !                     d1_o4(x(2) ,h ,g) , ( gpexact (2) - d1_o4 (x (2) ,h ,g ))/ gpexact (2)



 !    write (*,*) h, d1_o1(x (3) ,h , g) , ( gpexact (3) - d1_o1 (x (3) ,h ,g)) / gpexact (3) , &
 !                d1_o2 ( x (3) ,h ,g) , ( gpexact (3) - d1_o2 (x (3) ,h ,g ))/ gpexact (3) , &
 !                d1_o4 ( x (3) ,h ,g) , ( gpexact (3) - d1_o4 (x (3) ,h ,g ))/ gpexact (3)




 end do
 close (fu1)
 close (fu2)
 close (fu3)




end program p3
