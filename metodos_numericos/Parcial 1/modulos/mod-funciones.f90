module funciones

use isoprec

contains

!-----------------------------------------------------------------------------------------

function x_1(t)
    implicit none
    real(kind=wp) , intent(in) :: t
    real(kind=wp)              :: x_1
    x_1 = t-2
end function

!-----------------------------------------------------------------------------------------

function x_2(t)
    implicit none
    real(kind=wp) , intent(in) :: t
    real(kind=wp)              :: x_2
    x_2 = 100*exp((-1./10)*t)-2*t-94
end function

!-----------------------------------------------------------------------------------------

function deltax(t)
    implicit none
    real(kind=wp) , intent(in) :: t
    real(kind=wp)              :: deltax
    deltax = 100*(exp((-t*0.1_wp)))-3*t-92
end function

!-----------------------------------------------------------------------------------------

function ddeltax(t)
    implicit none
    real(kind=wp) , intent(in) :: t
    real(kind=wp)              :: ddeltax
    ddeltax = -10*(exp((-t*0.1_wp)))-3
end function

!-----------------------------------------------------------------------------------------

function MCDEuclides(m,p)
    implicit none
    integer(kind=il) , intent(in) :: m, p
    integer(kind=il)                 :: MCDEuclides
    MCDEuclides = mod(m,p)
end function

!-----------------------------------------------------------------------------------------

end module funciones