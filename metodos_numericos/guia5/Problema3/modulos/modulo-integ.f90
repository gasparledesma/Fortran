module inte_trape_simp

use ISOprec
use funciones

contains

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


subroutine puntomedio(integ ,a ,b , nn )

! ********************************************************************************************
! integral regla del punto medio
!
! integ = salida , resultado de la integral
! a = entrada , punto inferior del rango de integracion
! b = entrada , punto superior del rango de integracion
! nn = entrada , numero de intervalos, nn+1 = nro total de puntos
! h = intervalo , h = (b - a ) / nn !!!  
!
! funcion ( x ) = se usa funcion definida en modulo funciones
!
! *******************************************************************************************


implicit none

integer , intent ( in ) :: nn

real ( kind = wp ) , intent ( out ) :: integ
real ( kind = wp ) , intent ( in ) :: a , b
real ( kind = wp )                 :: h , x

integer :: j

h = (b - a ) /( 1.0_wp *  nn)


 ! recordar que acá nn es el número de intervalos

 ! recordar que a + nn * h =  b


integ = 0._wp

do j = 0 , nn-1
    
    x =  a +  h * ( 0.5_wp + j )
   
   !  x =  a +  h * ( 1.0_wp + 2.0_wp * j )/ 2.0_wp
    
    
    integ = integ + funcion( x )
    
end do

integ =  h * integ


end subroutine puntomedio







subroutine trapecio ( integ, a, b, nn )

! ********************************************************************************************
! integral regla de trapecio
!
! integ = salida , resultado de la integral
! a = entrada , punto inferior del rango de integracion
! b = entrada , punto superior del rango de integracion
! nn = entrada, numero de intervalos ; nn + 1 = numero total de puntos
! h = intervalo, largo del intervalo = (b - a ) / nn  
!
! funcion ( x ) = se usa funcion definida en modulo funciones
!
! *******************************************************************************************


implicit none

integer , intent ( in ) :: nn

real ( kind = wp ) , intent ( out ) :: integ
real ( kind = wp ) , intent ( in ) :: a, b
real ( kind = wp )                 :: h, x

integer :: j

print *, "número de puntos nn + 1 ", nn + 1

h = (b - a ) /( 1.0_wp * nn )


integ = 0._wp

 ! recordar que nn es el número de intervalos

 ! recordar que a + nn * h =  b

do j = 1 , nn-1

x =  a + j * h

integ = integ + funcion ( x )

end do

integ = h *(0.5_wp *(funcion(a) + funcion (b)) + integ )


end subroutine trapecio



! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



subroutine simpson ( integ ,a ,b , nn )

! *************************************************************************************************
! integral regla de Simpson
!
! integ = salida , resultado de la integral
! a = entrada , punto inferior del rango de integracion
! b = entrada , punto superior del rango de integracion
! nn = entrada , numero de intervalos ; nn +1 = numero total de puntos
! h = inteno , largo del intervalo = (b - a ) / nn 
!
! funcion ( x ) = se usa funcion definida en modulo funciones
!
! ************************************************************************************************

implicit none

integer , intent ( in ) :: nn

real ( kind = wp ) , intent ( out ) :: integ
real ( kind = wp ) , intent ( in ) :: a , b

real ( kind = wp ) :: h , integ1 , integ2 , x
integer :: j

print *, "número de puntos nn + 1 ", nn + 1
print *, " el número de intervalos nn debe ser par" 

if (2*((nn+1)/2) == (nn+1) ) then
  write (* ,*) " error subroutine simpson : "
  write (* ,*) " el numero nn de intervalos debe ser par "

integ = 0.0_wp


else

  

  !if (mod(nn,2) = 0) then
  
  h = (b - a)/( 1.0_wp *nn )
  
  ! recordar que nn es el número de intervalos
  
  integ1 = 0._wp

  ! recordar que a + nn * h =  b

  do j = 1 , nn-1 , 2   !   modificado en esta versión!!!
  
 !   print*, "J DESDE 1 , términos impares (x4)", J
      x = a + j * h
      integ1 = integ1 + funcion(x)

  end do


  print *, "x =", x

  integ2 = 0._wp
  
  do j = 2 , nn-2 , 2    !   modificado en esta versión!!!
 !    print*, "J DESDE 2 , términos pares (x2)", J
      x = a + j * h
      integ2 = integ2 + funcion(x)

  end do

print *, "x =", x
  integ = h *((funcion(a) + funcion(b)) + 4._wp * integ1 + 2._wp * integ2 )/3._wp


end if



end subroutine simpson

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


end module inte_trape_simp
