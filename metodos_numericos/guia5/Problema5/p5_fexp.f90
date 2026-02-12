program integracion
!
! cálculo de integral definida usando
! métodos de trapecio y regla de Simpson .
!
! Notar que en este programa : nn = número de evaluaciones
!
!   de la función



use ISOprec
use funciones
use pmedio_trape_simpson

implicit none

integer                               :: p , p_max , p_max3 , nn , nn2 , j , k , ntot, nMax, fu
real ( kind = wp )                    :: x_ini , x_fin , tol , h , x , integr ,err_1 , err_2 , int_exacta , q

integer                               :: t1 , t2 , clock_rate , clock_max
real ( kind = wp )                    :: start_time , end_time, error_rel, error_abs

!real (kind = wp), parameter          :: valorExacto = 0.632120558828557678404476229838539127_wp

! lectura de parametros -------------------------------------------------------------------
!namelist /parametroscmp/                       &
!                 tol     ! tolerancia permitida


!namelist /parametrosinic/                  &
!                x_ini , x_fin , nn ! rango de integracion [ x_ini , x_fin ] , numero total de puntos

! open  (unit = 100, file = "./datosent/paramscmp.in" , status = "old" )
! read  (unit = 100, nml = parametroscmp )
! close (unit = 100)

! open  (unit = 11, file = "./datosent/paramsinic-prob3.in" , status ="old" )
! read  (unit = 11, nml = parametrosinic )
! close (unit = 11)

x_ini = 0.0_wp
x_fin = 1.0_wp
nMax = 10


! ----------------------------------------------------------------------------------


print *, "            Cálculo de la integral exacta       "

int_exacta = 1.0_wp - exp(-1.0_wp)

print *, "int_exacta = ", int_exacta

print*, "          Cálculo de la integral mediante el puntomedio"

open ( newunit = fu , file = "./datossal/prob4PuntoMediofexp.datos" , status = "unknown")

write (fu,*)   " nMax                        integr                         error-rel                     h  "
write (* ,*)   " nMax                        integr                         error-rel                     h  "

do j = 0, 9

   nMax = 10 * 2**j +1

   nn = nMax - 1

   h =  ( x_fin - x_ini )/ nn      

   call puntomedio (integr, x_ini, x_fin, nn , fexp)

   error_abs = (integr - int_exacta)
   error_rel = abs((integr - int_exacta)/int_exacta)

   write (fu, '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') nMax, integr , error_rel,  h
   write (* , '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') nMax, integr , error_rel,  h

end do

close(fu)

print*, "      Cálculo de la integral mediante el trapecio"

open ( newunit = fu , file = "./datossal/prob4Trapezoidalfexp.datos" , status = "unknown")

write (fu,*)   " nMax                        integr                         error-rel                      h  "
write (* ,*)   " nMax                        integr                         error-rel                      h  "

do j = 0, 9

   nMax = 10 * 2**j +1

   nn = nMax - 1

    h =  ( x_fin - x_ini )/(nMax-1)

   call trapecio(integr, x_ini, x_fin, nMax, fexp)

   error_abs = (integr - int_exacta)
   error_rel = abs((integr - int_exacta)/int_exacta)

   write (fu , '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') nMax, integr , error_rel,  h
   write (* ,  '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') nMax, integr , error_rel,  h

end do

close(fu)

print*, "                 Cálculo de la integral mediante  Simpson             "
open ( newunit = fu , file = "./datossal/prob4Simponfexp.datos" , status = "unknown")

write (fu,*)   " nMax                       integr                         error-rel                      h  "
write (* ,*)   " nMax                       integr                         error-rel                      h  "

do j = 0, 9

   nMax = 10 * 2**j + 1

  nn = nMax - 1

   h =  ( x_fin - x_ini )/ nn      

   call Simpson(integr, x_ini, x_fin, nn , fexp)

   error_abs =  integr - int_exacta
   error_rel = abs((integr - int_exacta)/int_exacta)

   write (fu, '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') nMax, integr , error_rel,  h
   write (* , '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') nMax, integr , error_rel,  h

end do

close(fu)

end program integracion
