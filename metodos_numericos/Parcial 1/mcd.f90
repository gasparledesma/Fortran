program mcd 

!---LEIVA-ESTEBAN---Y---GASPAR-LEDESMA----------------------------------------------------

use isoprec
use funciones

implicit none

!-----------------------------------------------------------------------------------------

integer(kind=il) :: a, b, r
integer          :: iter

write(*,*)"Ingrese el primer número:"
read(*,*)a 
write(*,*)"Ingrese el segundo número:"
read(*,*)b

if((a==0).or.(b==0)) then
    write(*,*)"Ninguno de los números puede ser nulo"
    stop
endif

iter=1

if(a==b) then
    write(*,*)"El MCD entre los números es: ",a
    write(*,*)"Iteraciones totales del algoritmo de Euclides: ",1
elseif(a>b) then
    if(MCDEuclides(a,b)==0) then
        write(*,*)"El MCD entre los números es: ",b
        write(*,*)"Iteraciones totales del algoritmo de Euclides: ",1
    else
        do
            r=MCDEuclides(a,b)
            a=b
            b=r
            iter=iter+1
            if(MCDEuclides(a,b)==0) then
                write(*,*)"El MCD entre los números es: ",r
                write(*,*)"Iteraciones totales del algoritmo de Euclides: ",iter
                exit
            end if
        end do
    end if
else
    if(MCDEuclides(b,a)==0) then
        write(*,*)"El MCD entre los números es: ",a
        write(*,*)"Iteraciones totales del algoritmo de Euclides: ",1
    else
        do
            r=MCDEuclides(b,a)
            b=a
            a=r
            iter=iter+1
            if(MCDEuclides(b,a)==0) then
                write(*,*)"El MCD entre los números es: ",r
                write(*,*)"Iteraciones totales del algoritmo de Euclides: ",iter
                exit
            end if
        end do
    end if
end if

end program mcd