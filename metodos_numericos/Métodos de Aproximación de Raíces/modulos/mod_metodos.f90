module metodos

use ISOprec
use funciones

implicit none

contains

!---BISECCION-----------------------------------------------------------------------------

subroutine biseccion(f, a, b, tolx, iter, r)

    implicit none

    real(kind=wp) , intent(in)  :: a, b, tolx
    real(kind=wp) , intent(out) :: r
    integer , intent(out)       :: iter
    real(kind=wp) , allocatable :: v(:)
    real(kind=wp)               :: f, a0, b0
    integer                     :: i

    a0=a
    b0=b

    iter=0
    iter=floor(log((b0-a0)/tolx)/log(2._wp))+1
    allocate(v(iter))

    if(f(a0)<0) then
        do i=1,iter,1
          v(i)=a0+(b0-a0)/2
            if(f(v(i))>0) then
                b0=v(i)
            else
                a0=v(i)
            endif
        end do
    else
        do i=1,iter,1
            v(i)=a0+(b0-a0)/2
            if(f(v(i))<0) then
                b0=v(i)
            else
                a0=v(i)
            endif
        end do
    end if

    r=v(iter)

end subroutine

!---SECANTE-------------------------------------------------------------------------------

subroutine secante(f, a, b, tolx, itmax, r, iter)

    implicit none

    real(kind=wp) , intent(in)  :: a, b, tolx
    real(kind=wp) , intent(out) :: r
    real(kind=wp)               :: v(itmax)
    real(kind=wp)               :: f, fa, fb, a0, b0
    integer                     :: i, iter, itmax

    a0=a 
    b0=b

    fa=f(a0)
    fb=f(b0)
    iter=0

    do i=1,itmax,1
        v(i)=b0-f(b0)*((b0-a0)/(f(b0)-f(a0)))
        b0=v(i)
        iter=iter+1
        if((tolx>abs(v(i)-v(i-1)))) then
            r=v(i)
            exit
        else
            r=v(i)
        end if
    end do

end subroutine

!---REGULA-FALSI--------------------------------------------------------------------------

subroutine regulafalsi(f, a, b, tolx, itmax, r, iter)

    implicit none

    real(kind=wp) , intent(in)  :: a, b, tolx
    real(kind=wp) , intent(out) :: r
    real(kind=wp)               :: v(itmax)
    real(kind=wp)               :: f, fa, fb, a0, b0
    integer                     :: i, iter, itmax

    a0=a
    b0=b

    fa=f(a0)
    fb=f(b0)
    iter=0

    do i=1,itmax,1
        v(i)=a0-((f(a0)*(b0-a0))/(f(b0)-f(a0)))
        if(sign(1._wp, fa)==sign(1._wp, f(v(i)))) then
            a0=v(i)    
        else
            b0=v(i)
        end if
        iter=iter+1
        if((tolx>abs(v(i)-v(i-1)))) then
            r=v(i)
            exit
        else
            r=v(i)
        end if
    end do
    
end subroutine


!---NEWTON-RAPHSON------------------------------------------------------------------------

subroutine newtonraphson(x0, f, df, tolx, toly, itmax, r, iter)

    implicit none

    real(kind=wp) , intent(in)  :: x0, tolx, toly
    real(kind=wp) , intent(out) :: r
    real(kind=wp)               :: v(itmax)
    real(kind=wp)               :: f, df
    integer                     :: i, iter, itmax

    iter=0
    v(1)=x0

    do i=2,itmax,1
        v(i)=v(i-1)-(f(v(i-1))/df(v(i-1)))
        iter=iter+1
        if ((tolx>((v(i)-v(i-1))/(v(i-1)))).and.(toly>abs(f(v(i))))) then
            r=v(i)
            exit
        end if
    end do

end subroutine

end module metodos