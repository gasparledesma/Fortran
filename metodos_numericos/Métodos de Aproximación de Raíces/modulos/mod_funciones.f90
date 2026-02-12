module funciones

use ISOprec

contains

!-----------------------------------------------------------------------------------------

function f(x)
    implicit none
    real(kind=wp) , intent(in) :: x
    real(kind=wp)              :: f
    f = x**4 - 0.5*x**3 - x**2 + 5*x - 6
end function

!-----------------------------------------------------------------------------------------

function df(x)
    implicit none
    real(kind=wp) , intent(in) :: x
    real(kind=wp)              :: df
    df = 4*x**3 - 1.5*x**2 - 2*x + 5
end function

!-----------------------------------------------------------------------------------------

function g(x)
    implicit none
    real(kind=wp) , intent(in) :: x
    real(kind=wp)              :: g
    g = tan(x) + 2*x
end function

!-----------------------------------------------------------------------------------------

function dg(x)
    implicit none
    real(kind=wp) , intent(in) :: x
    real(kind=wp)              :: dg
    dg = 1._wp/cos(x)**2 + 2
end function

!-----------------------------------------------------------------------------------------

end module funciones