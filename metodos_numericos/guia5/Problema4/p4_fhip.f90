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

integer                               :: p , p_max , p_max3 , nn , nn2 
integer                               :: j , k , ntot, nMax, fu , q
real ( kind = wp )                    :: x_ini , x_fin , tol , h , x 
real ( kind = wp)                     :: integr ,err_1 , err_2 , int_exacta 

integer                               :: t1 , t2 , clock_rate , clock_max
real ( kind = wp )                    :: start_time , end_time, error
!real (kind = wp), parameter          :: valorExacto = -0.26706278524904524629268724186_wp

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
x_fin = 0.5_wp
nMax = 100
print *, "nMax=", nMax
! ---------------------------------------------------------------------------

print *, "                Cálculo de la integral exacta                "


int_exacta =  2.0_wp*(log(4.0_wp-x_fin) - log(4.0_wp-x_ini))

print *, "int_exacta = ", int_exacta

print*, "           Cálculo de la integral mediante el puntomedio"

open ( newunit = fu , file = "./datossal/prob4PuntoMediofHip.datos" , status = "unknown")

write (fu ,*) " j                        integr                         integral-int_exacta                     h  "
write (* ,*)   " j                        integr                         integral-int_exacta                     h  "

do j = 2, nMax, 2

   call puntomedio (integr, x_ini, x_fin, j, fhip)

error = int_exacta - integr

write (fu, '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') j, integr , error,  ( x_fin - x_ini ) /( 1.0 _wp *( j -1) )
write (* , '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') j, integr , error,  ( x_fin - x_ini ) /( 1.0 _wp *( j -1) )

end do

close(fu)
print*, "           Cálculo de la integral mediante el trapecio         "
open ( newunit = fu , file = "./datossal/prob4TrapezoidalfHip.datos" , status = "unknown")

write (fu ,*) " j                        integr                         integral-int_exacta                     h  "
write (* ,*)   " j                        integr                         integral-int_exacta                     h  "

do j = 2, nMax, 2

   call trapecio(integr, x_ini, x_fin, j, fhip)

error = int_exacta - integr

write (fu,  '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') j, integr , error,  ( x_fin - x_ini ) /( 1.0 _wp *( j -1) )
write (* ,  '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') j, integr , error,  ( x_fin - x_ini ) /( 1.0 _wp *( j -1) )
end do

close(fu)

print*, "           Cálculo de la integral mediante Simpson       "
open ( newunit = fu , file = "./datossal/prob4SimponfHip.datos" , status = "unknown")

write (fu,*)  " j                        integr                         integral-int_exacta                     h  "
write (* ,*)  " j                        integr                         integral-int_exacta                     h  "

do j = 2, nMax, 2

   call Simpson(integr, x_ini, x_fin, j, fhip)

error = int_exacta - integr

write (fu, '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') j, integr , error,  ( x_fin - x_ini ) /( 1.0 _wp *( j -1) )
write (* , '( I4, 3x, e42.35 , 3X , e42.35 , 3X , e42.35 ) ') j, integr , error,  ( x_fin - x_ini ) /( 1.0 _wp *( j -1) )
end do

close(fu) 





end program integracion
