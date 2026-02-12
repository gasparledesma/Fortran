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
use inte_trape_simp

implicit none

integer                               :: p , p_max , p_max3 , nn , nn2 , j , k , ntot, fu
real ( kind = wp )                    :: x_ini , x_fin , tol , h , x , integr ,err_1 , err_2 , int_exacta , q

integer                               :: t1 , t2 , clock_rate , clock_max
real ( kind = wp )                    :: start_time , end_time

! lectura de parametros -------------------------------------------------------------------
namelist /parametroscmp/                       &
                 tol     ! tolerancia permitida


namelist /parametrosinic/                  &
                x_ini , x_fin , nn ! rango de integracion [ x_ini , x_fin ] , numero total de intervalos

 open  (newunit = fu, file = "./datosent/paramscmp.in" , status = "old" )
 read  (unit = fu, nml = parametroscmp )
 close (unit = fu)

 open  (newunit = fu, file = "./datosent/paramsinic-prob3.in" , status ="old" )
 read  (unit = fu, nml = parametrosinic )
 close (unit = fu)


 ! ------------------------------------------------------------------
 
 
 open ( newunit = fu , file = "./datossal/salidas-prob3.datos" , status = "unknown")

write (* ,*)     "x_ini =" , x_ini
write (* ,*)     "x_fin =" , x_fin

write (* ,*)     "nn =" ,nn
write (* ,*)     " h =" ,( x_fin - x_ini ) /( 1.0_wp * nn)
write (fu ,*)   " x_ini = " , x_ini
write (fu ,*)   " x_fin ="  , x_fin

write (fu ,*) " nn = " , nn
write (fu ,*) " h =" ,( x_fin - x_ini ) /( 1.0_wp * nn )

write (* ,*) ' tol = ',tol , ' no se usa en este problema, pero si en el siguiente '
write (* ,*) " "
write (fu,*) " "


!!!!***************************************************************************

!!!!!!!!                         Cálculo integral exacta 

print *, "Calculo integral exacta" 

int_exacta = -( funcion ( x_fin ) - funcion ( x_ini ))

write(*,*) "integral exacta de exp(-x) = ", int_exacta

!!*****************************************************************************

!!!!!!!!!!!!!!!!                   Calculamos integral usando punto medio 

print *, " Calculo punto medio "

print *, " Primera vez "


!call cpu_time ( start_time )
call puntomedio (integr, x_ini, x_fin, nn)

! ----------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------

write (* , '( a33 , e42.35 , a7 , e42.35 , a7 , i7 ) ') " integral regla de puntomedio = " , integr , &
          " h = " ,( x_fin - x_ini ) /( 1.0 _wp * nn ) ," nn = " ,nn

write (fu , '( a33 , e42.35 , a7 , e42.35 , a7 , i7 ) ') " integral regla de puntomedio = " , integr , &
         " h =  " ,( x_fin - x_ini ) /( 1.0 _wp * nn ) ," nn = " ,nn

 err_1 = int_exacta - integr
 
 
print *, " Segunda vez "


 
 nn2 = 2 * nn
 
 call puntomedio ( integr , x_ini , x_fin , nn2 )
 
!call cpu_time ( end_time )
 
! write ( *, * ) ' medidas del tiempo de ejecución: '
! write (fu, * ) ' medidas del tiempo de ejecución: '
! write ( *, * ) ' Elapsed CPU time = ', start_time - end_time
! write (fu, * ) ' Elapsed CPU time = ', start_time - end_time

 write ( *, * )
 write (fu, * )

 ! ------------------------------------------------------------------------------------

 write (* , '( a33 ,e42.35 , a7 ,e42.35 , a7 , i7 ) ') " integral regla de puntomedio = " , integr , &
                    " h = " ,( x_fin - x_ini ) /( 1.0_wp * nn2 ) ," nn2 = " , nn2

write (fu, '( a33 ,e42.35 , a7 ,e42.35 , a7 , i7 ) ') " integral regla de puntomedio = " , integr , &
                    " h = " ,( x_fin - x_ini ) /( 1.0_wp * nn2 ) ," nn2 = " , nn2


err_2 = int_exacta - integr

q = err_1 / err_2

write (* ,*) " "
write (fu,*) " "
write (* ,*) "Q_puntomedio = " ,q
write (fu,*) "Q_puntomedio = " ,q

write (* ,*) " "
write (fu ,*) " "



!!!!!*****************************************************************************

!!!!                  Cálculamos integral mediante trapecio

print *, " Calculo trapecio "

print *, " Primera vez "

!--------------------------------------------------------------------------------
! medida del tiempo de ejecucion ------------------------------------------------

!call cpu_time ( start_time )

call trapecio (integr, x_ini, x_fin, nn)

! -------------------------------------------------------------------------------
! -------------------------------------------------------------------------------

write (* , '( a33 , e42.35 , a7 , e42.35 , a7 , i7 ) ') " integral regla de trapecio = " , integr , &
          " h = " ,( x_fin - x_ini ) /( 1.0 _wp * nn  ) ," nn = " ,nn

write (fu , '( a33 , e42.35 , a7 , e42.35 , a7 , i7 ) ') " integral regla de trapecio = " , integr , &
         " h =  " ,( x_fin - x_ini ) /( 1.0 _wp * nn  ) ," nn = " ,nn

 err_1 = int_exacta - integr
 
 
print *, " Segunda vez "
 
 nn2 = 2 * nn 
 
 call trapecio ( integr , x_ini , x_fin , nn2 )
 
!call cpu_time ( end_time )
 
! write ( *, * ) ' medidas del tiempo de ejecución: '
! write (fu , *) ' medidas del tiempo de ejecución: '
! write ( *, * ) ' Elapsed CPU time = ', start_time - end_time
! write (fu , *) ' Elapsed CPU time = ', start_time - end_time

 write ( *, * )
 write (fu , * )

 ! ----------------------------------------------------

 write (* , '( a33 ,e42.35 , a7 ,e42.35 , a7 , i7 ) ') " integral regla de trapecio = " , integr , &
                    " h = " ,( x_fin - x_ini ) /( 1.0_wp * nn2 ) ," nn2 = " , nn2

write (fu, '( a33 ,e42.35 , a7 ,e42.35 , a7 , i7 ) ') " integral regla de trapecio = " , integr , &
                    " h = " ,( x_fin - x_ini ) /( 1.0_wp * nn2 ) ," nn2 = " , nn2


err_2 = int_exacta - integr

q = err_1 / err_2

write(* ,*) " "
write (fu ,*) " "
write(* ,*) "Q_trapecio = " ,q
write(fu ,*) "Q_trapecio = " ,q

write (* ,*) " "
write (fu ,*) " "

!!!!!*****************************************************************************

!!!!!!! Cálculo de integral mediante  Simpson

print *, " Calculo Simpson "

print *, " Primera vez "

! medida del tiempo de ejecucion ------------------------------------------

!call cpu_time ( start_time )

call simpson ( integr , x_ini , x_fin , nn )

! --------------------------------------------------------------------------


write (* , '( a33 ,e42.35 ,a7 ,e42.35 ,a7 ,i7)') " integral de Simpson = ", integr, &
             "  h =  ",( x_fin - x_ini ) /( 1.0 _wp * nn ) ," nn = " ,nn

write (fu, '( a33 ,e42.35 ,a7 ,e42.35 ,a7 ,i7)') " integral de Simpson = ", integr, &
                          "  h =  ",( x_fin - x_ini ) /( 1.0 _wp * nn ) ," nn = " ,nn

err_1 = int_exacta - integr

print *, " Segunda vez "

nn2 = 2 * nn 

call simpson ( integr , x_ini , x_fin , nn2 )

!call cpu_time ( end_time )

!write ( *, * ) ' medidas del tiempo de ejecución : '
!write (fu, * ) ' medidas del tiempo de ejecución: '
!write ( *, * ) ' Elapsed CPU time = ', start_time - end_time
!write (fu, * ) ' Elapsed CPU time = ', start_time - end_time

write (* ,*)  " "
write (fu,*)  " "



write (* , '( a33 ,e42.35 ,a7 ,e42.35 ,a7 ,i7)') " integral de Simpson = ", integr, &
             "  h =  ",( x_fin - x_ini ) /( 1.0 _wp * nn2 ) ," nn = " ,nn2

write (fu, '( a33 ,E42.35 ,a7 ,e42.35 ,a7 ,i7)') " integral de Simpson = ", integr, &
                          "  h =  ",( x_fin - x_ini ) /( 1.0 _wp * nn2 ) ," nn2 = " ,nn2


err_2 = int_exacta - integr

q = err_1 /err_2

write (* ,*) " "
write (fu ,*) " "

write (* ,*)   " Q_simpson = " , q
write (fu,*)   " Q_simpson = " , q


write (*,*)  " "
write (fu, *) " "

write (* ,'( a33 ,E42.35 )')   " integral exacta = " , int_exacta
write (fu ,*) " integral exacta = " , int_exacta

close ( unit = fu)

end program integracion
