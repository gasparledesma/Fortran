module metodos

use isoprec
use funciones

implicit none

contains

!---BISECCION-----------------------------------------------------------------------------

subroutine biseccion(f, a, b, tolx, toly, itmax, r, iter, relx, absy)

    implicit none

    real(kind=wp)    , intent(in)  :: a, b, tolx, toly
    integer(kind=is) , intent(in)  :: itmax
    real(kind=wp)    , intent(out) :: r, relx, absy
    real(kind=wp)                  :: v(itmax)
    real(kind=wp)                  :: f, a0, b0
    integer                        :: i, iter

    a0=a 
    b0=b
    iter=0

    open(unit=10, file='datos/biseccion.dat')

    if(f(a)<0) then
        do i=1,itmax,1
          v(i)=a0+(b0-a0)/2
          r=v(i)
          iter=iter+1
          relx=(b0-a0)/2.
          absy=abs(f(v(i)))
          write(10,*)iter, r, relx, absy
            if(f(v(i))>0) then
                b0=v(i)
            else
                a0=v(i)
            endif
            if((tolx>relx).and.(toly>absy)) then
                exit
            end if
        end do
    else
        do i=1,itmax,1
            v(i)=a0+(b0-a0)/2
            r=v(i)
            iter=iter+1
            relx=(b0-a0)/2.
            absy=abs(f(v(i)))
            write(10,*)iter, r, relx, absy
              if(f(v(i))<0) then
                  b0=v(i)
              else
                  a0=v(i)
              endif
              if((tolx>relx).and.(toly>absy)) then
                  exit
              end if
          end do
    end if

    close(unit=10)

end subroutine

!---SECANTE-------------------------------------------------------------------------------

subroutine secante(f, a, b, tolx, toly, itmax, r, iter, relx, absy)

    implicit none

    real(kind=wp)    , intent(in)  :: a, b, tolx, toly
    integer(kind=is) , intent(in)  :: itmax
    real(kind=wp)    , intent(out) :: r, relx, absy
    real(kind=wp)                  :: v(itmax)
    real(kind=wp)                  :: f
    integer                        :: i, iter

    open(unit=11, file='datos/secante.dat')

    v(1)=a
    write(11,*) 1, a, abs(b-a), abs(deltax(a))
    v(2)=b
    write(11,*) 2, b, abs(b-a), abs(deltax(b))
    iter=2

    do i=3,itmax,1
        v(i)=v(i-1)-f(v(i-1))*((v(i-1)-v(i-2))/(f(v(i-1))-f(v(i-2))))
        r=v(i)
        relx=abs(v(i)-v(i-1))/(v(i-1))
        absy=abs(f(v(i)))
        iter=iter+1
        write(11,*)iter, r, relx, absy
        if((tolx>relx).and.(toly>absy)) then
            exit
        end if
    end do

    close(unit=11)
end subroutine

!---NEWTON-RAPHSON------------------------------------------------------------------------

subroutine newtonraphson(x0, f, df, tolx, toly, itmax, r, iter, relx, absy)

    implicit none

    real(kind=wp) , intent(in)    :: x0, tolx, toly
    integer(kind=is) , intent(in) :: itmax
    real(kind=wp) , intent(out)   :: r, relx, absy
    real(kind=wp)                 :: v(itmax)
    real(kind=wp)                 :: f, df
    integer                       :: i, iter

    open(unit=12, file='datos/newton.dat')

    iter=1
    v(1)=x0-(f(x0)/df(x0))
    write(12,*)1,v(1),abs(v(1)-x0),abs(deltax(v(1)))

    do i=2,itmax,1
        iter=iter+1
        v(i)=v(i-1)-(f(v(i-1))/df(v(i-1)))
        r=(v(i))
        relx=abs((v(i)-v(i-1))/(v(i-1)))
        absy=abs(f(v(i)))
        write(12,*)iter,r,relx,absy
        if((tolx>relx).and.(toly>absy)) then
            exit
        end if
    end do

    close(unit=12)

end subroutine

end module metodos