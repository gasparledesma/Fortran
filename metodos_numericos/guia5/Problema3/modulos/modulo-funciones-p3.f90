module funciones
use ISOprec

contains

! __________________________________________
function funcion ( x )

implicit none

real ( kind = wp ) , intent ( in ) :: x
real ( kind = wp ) :: funcion


funcion = exp(-x)

end function funcion


end module funciones
