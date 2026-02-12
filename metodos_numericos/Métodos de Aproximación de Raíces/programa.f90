program raices

use isoprec
use funciones
use metodos

implicit none

real(kind=wp) :: a, b, fa, fb, tolx, toly, x0, r
integer :: iter, itmax

tolx=0._wp
toly=0._wp

write(*,*)"Ingrese el valor de tolerancia de error en X"
read(*,*)tolx

if(tolx<=0) then
    write(*,*)"La tolerancia no puede ser negativa ni nula"
    stop
end if

write(*,*)"Ingrese el valor de tolerancia de error en Y"
read(*,*)toly

if(toly<=0) then
    write(*,*)"La tolerancia no puede ser negativa ni nula"
    stop
end if

!---BISECCION-----------------------------------------------------------------------------

write(*,*)"----------METODO DE BISECCION----------"
write(*,*)"Ingrese el valor de A para el método de bisección"
read(*,*)a
write(*,*)"Ingrese el valor de B para el método de bisección"
read(*,*)b

if(a>b) then
    write(*,*)"El valor de A debe ser menor al valor de B"
    stop
end if

fa=0._rl
fb=0._rl

fa=f(a)
fb=f(b)

if(sign(1._wp, fa)==sign(1._wp, fb)) then
    write(*,*)"Los signos de la funcion en A y B son iguales"
    stop
end if

call biseccion(f, a, b, tolx, iter, r)

write(*,*)"La raiz aproximada es: ", r
write(*,*)"Y su valor en la función es: ", f(r)
write(*,*)"La cantidad de iteraciones realizadas son: ", iter

!---SECANTE-------------------------------------------------------------------------------

write(*,*)"----------METODO DE LA SECANTE----------"
write(*,*)"Ingrese el valor de A para el método de la secante"
read(*,*)a
write(*,*)"Ingrese el valor de B para el método de la secante"
read(*,*)b

if(a>b) then
    write(*,*)"El valor de A debe ser menor al valor de B"
    stop
end if

fa=f(a)
fb=f(b)

if(fa==fb) then
    write(*,*)"Los valores de A y B en la funcion no pueden ser iguales"
    stop
end if

write(*,*)"Ingrese la cantidad máxima de iteraciones deseadas"
read(*,*)itmax
if(itmax<=0) then
    write(*,*)"La cantidad de iteraciones no puede ser negativa ni nula"
    stop
endif

call secante(f, a, b, tolx, itmax, r, iter)

write(*,*)"Si el método converge, obtenemos que:"
write(*,*)"La raiz aproximada es: ", r
write(*,*)"Y su valor en la función es: ", f(r)
write(*,*)"La cantidad de iteraciones realizadas son: ", iter

!---REGULA-FALSI--------------------------------------------------------------------------

write(*,*)"----------METODO REGULA-FALSI----------"
write(*,*)"Ingrese el valor de A para el método regula-falsi"
read(*,*)a
write(*,*)"Ingrese el valor de B para el método regula-falsi"
read(*,*)b

fa=f(a)
fb=f(b)

if(sign(1._wp, fa)==sign(1._wp, fb)) then
    write(*,*)"Los signos de la funcion en A y B son iguales"
    stop
end if

write(*,*)"Ingrese la cantidad máxima de iteraciones deseadas"
read(*,*)itmax
if(itmax<=0) then
    write(*,*)"La cantidad de iteraciones no puede ser negativa ni nula"
    stop
endif

call regulafalsi(f, a, b, tolx, itmax, r, iter)

write(*,*)"Si el método converge, obtenemos que:"
write(*,*)"La raiz aproximada es: ", r
write(*,*)"Y su valor en la función es: ", f(r)
write(*,*)"La cantidad de iteraciones realizadas son: ", iter

!---NEWTON-RAPHSON------------------------------------------------------------------------

write(*,*)"----------METODO NEWTON-RAPHSON----------"
write(*,*)"Ingrese una aproximación inicial de la raiz: "
read(*,*)x0

if(df(x0)==0) then
    write(*,*)"La derivada en la aproximación no puede valor cero"
    stop
end if

write(*,*)"Ingrese la cantidad máxima de iteraciones deseadas"
read(*,*)itmax
if(itmax<=0) then
    write(*,*)"La cantidad de iteraciones no puede ser negativa ni nula"
    stop
endif

call newtonraphson(x0, f, df, tolx, toly, itmax, r, iter)

write(*,*)"La raiz aproximada es: ", r
write(*,*)"Y su valor en la función es: ", f(r)
write(*,*)"La cantidad de iteraciones realizadas son: ", iter

end program raices