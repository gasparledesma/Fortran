module funciones
use ISOprec

contains

! ------------------------------------------------------------------
function fexp ( x )

implicit none

real ( kind = wp ) , intent ( in ) :: x
real ( kind = wp ) :: fexp


fexp = exp(-x)

end function fexp

!--------------------------------------------------------------------

function fhip ( x )

implicit none

real ( kind = wp ) , intent ( in ) :: x
real ( kind = wp ) :: fhip


fhip = - 2.0_wp /( 4.0_wp - x)

end function fhip

!--------------------------------------------------------------------


function fx2ln ( x )

implicit none

real ( kind = wp ) , intent ( in ) :: x
real ( kind = wp ) :: fx2ln


fx2ln = x**2.0_wp * log(x)

end function fx2ln

!--------------------------------------------------------------------













end module funciones
