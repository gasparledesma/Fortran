program p1mcd 

    !---LEIVA-ESTEBAN---Y---GASPAR-LEDESMA----------------------------------------------------
    
    use isoprec
    use funciones
    
    implicit none
    
    !-----------------------------------------------------------------------------------------
    
    integer(kind=il) :: a, b, r, c, d, t, e, f, y
    integer          :: iter
    
    write(*,*) "caso 1"

    a = 85
    b = 195
    write(*,*)"a:"a
    write(*,*)"b:"b
    
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
    
    write(*,*) " "

   !-----------------------------------------------------------------------------------------
   
    write(*,*) "caso 2"

    c = 357
    d = 273
    write(*,*)"a:"c
    write(*,*)"b:"d
    
    if((c==0).or.(d==0)) then
        write(*,*)"Ninguno de los números puede ser nulo"
        stop
    endif
    
    iter=1
    
    if(c==d) then
        write(*,*)"El MCD entre los números es: ",c
        write(*,*)"Iteraciones totales del algoritmo de Euclides: ",1
    elseif(c>d) then
        if(MCDEuclides(c,d)==0) then
            write(*,*)"El MCD entre los números es: ",d
            write(*,*)"Iteraciones totales del algoritmo de Euclides: ",1
        else
            do
                t=MCDEuclides(c,d)
                c=d
                d=t
                iter=iter+1
                if(MCDEuclides(c,d)==0) then
                    write(*,*)"El MCD entre los números es: ",t
                    write(*,*)"Iteraciones totales del algoritmo de Euclides: ",iter
                    exit
                end if
            end do
        end if
    else
        if(MCDEuclides(d,c)==0) then
            write(*,*)"El MCD entre los números es: ",c
            write(*,*)"Iteraciones totales del algoritmo de Euclides: ",1
        else
            do
                t=MCDEuclides(d,c)
                d=c
                c=t
                iter=iter+1
                if(MCDEuclides(d,c)==0) then
                    write(*,*)"El MCD entre los números es: ",t
                    write(*,*)"Iteraciones totales del algoritmo de Euclides: ",iter
                    exit
                end if
            end do
        end if
    end if
    
    write(*,*) " "

 !-----------------------------------------------------------------------------------------

    write(*,*) "caso 3"

    e = 41595141
    f = 44173857
    write(*,*)"a:"e
    write(*,*)"b:"f
    
    if((e==0).or.(f==0)) then
        write(*,*)"Ninguno de los números puede ser nulo"
        stop
    endif
    
    iter=1
    
    if(e==f) then
        write(*,*)"El MCD entre los números es: ",e
        write(*,*)"Iteraciones totales del algoritmo de Euclides: ",1
    elseif(e>f) then
        if(MCDEuclides(e,f)==0) then
            write(*,*)"El MCD entre los números es: ",f
            write(*,*)"Iteraciones totales del algoritmo de Euclides: ",1
        else
            do
                y=MCDEuclides(e,f)
                e=f
                f=y
                iter=iter+1
                if(MCDEuclides(e,f)==0) then
                    write(*,*)"El MCD entre los números es: ",y
                    write(*,*)"Iteraciones totales del algoritmo de Euclides: ",iter
                    exit
                end if
            end do
        end if
    else
        if(MCDEuclides(f,e)==0) then
            write(*,*)"El MCD entre los números es: ",e
            write(*,*)"Iteraciones totales del algoritmo de Euclides: ",1
        else
            do
                r=MCDEuclides(f,e)
                f=e
                e=y
                iter=iter+1
                if(MCDEuclides(f,e)==0) then
                    write(*,*)"El MCD entre los números es: ",y
                    write(*,*)"Iteraciones totales del algoritmo de Euclides: ",iter
                    exit
                end if
            end do
        end if
    end if
    
    end program p1mcd