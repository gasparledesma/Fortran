program parcial1

!---LEIVA-ESTEBAN---Y---GASPAR-LEDESMA----------------------------------------------------

use isoprec
use funciones
use metodos

implicit none

!-----------------------------------------------------------------------------------------

real(kind=wp)    , parameter :: a=0.0 , b=5.0 , tolx=1.e-8_wp
real(kind=wp)    , parameter :: x0=a , x1=b , p0=a , toly=tolx
integer(kind=is) , parameter :: maxite=100

real(kind=wp)                :: p, b_relx, b_absy, s_relx, s_absy, n_relx, n_absy, t
integer                      :: i, ite

500 format(X,A,2X,F18.15)
550 format(X,A,2X,I3)

!-----------------------------------------------------------------------------------------

write(*,*)" "
write(*,*)"MÉTODO DE BISECCIÓN"
write(*,*)" "

call biseccion(deltax, a, b, tolx, toly, maxite, p, ite, b_relx, b_absy)

write(*,550)"Iteraciones realizadas: ", ite
write(*,500)"Aproximacion de raiz:", p
write(*,500)"Aproximacion del valor en funcion:", x_1(p)
write(*,500)"Aproximacion de error relativo en X:", b_relx
write(*,500)"Aproximacion de error absoluto en Y:", b_absy
if(ite==maxite) then
    write(*,*)"El programa no convergió para el número máximo de iteraciones"
endif

write(*,*)" "
write(*,*)"MÉTODO DE LA SECANTE"
write(*,*)" "

call secante(deltax, a, b, tolx, toly, maxite, p, ite, s_relx, s_absy)

write(*,550)"Iteraciones realizadas: ", ite
write(*,500)"Aproximacion de raiz:", p
write(*,500)"Aproximacion del valor en funcion:", x_1(p)
write(*,500)"Aproximacion de error relativo en X:", s_relx
write(*,500)"Aproximacion de error absoluto en Y:", s_absy
if(ite==maxite) then
    write(*,*)"El programa no convergió para el número máximo de iteraciones"
endif

write(*,*)" "
write(*,*)"MÉTODO DE NEWTON-RAPHSON"
write(*,*)" "

call newtonraphson(p0, deltax, ddeltax, tolx, toly, maxite, p, ite, n_relx, n_absy)

write(*,550)"Iteraciones realizadas: ", ite
write(*,500)"Aproximacion de raiz:", p
write(*,500)"Aproximacion del valor en funcion:", x_1(p)
write(*,500)"Aproximacion de error relativo en X:", n_relx
write(*,500)"Aproximacion de error absoluto en Y:", n_absy
if(ite==maxite) then
    write(*,*)"El programa no convergió para el número máximo de iteraciones"
endif
write(*,*)" "

open(unit=13, file='datos/p2-funciones.dat')
t=a
do i=0, 600
    t=a+i*abs(b-a)/600
    write(13,*) t, x_1(t), x_2(t), deltax(t)
end do
close(unit=13)

end program parcial1