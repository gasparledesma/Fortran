module funciones

use ISOprec

contains

! ****************************************************************

function ff(x)
implicit none

real(kind = wp), intent(in)     :: x
real(kind = wp)                 :: ff

ff  =  exp( x )

end function

! ********************************************************************

function ffprima_exacta(x)

implicit none

real(kind = wp), intent(in)        :: x
real(kind = wp)                    :: ffprima_exacta

ffprima_exacta = exp(x)

end function

! ********************************************************************

function g(x)
implicit none

real(kind = wp), intent(in)     :: x
real(kind = wp)                 :: g

g  =  cos(x)

end function

! *********************************************************************

function gprima_exacta(x)

implicit none

real(kind = wp), intent(in)        :: x
real(kind = wp)                    :: gprima_exacta

gprima_exacta = - sin(x)

end function



end module funciones
