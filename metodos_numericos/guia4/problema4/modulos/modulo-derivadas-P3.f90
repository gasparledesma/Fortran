module derivadas1


use ISOprec
use funciones


contains
  ! ***********************************************************************

  function d1_o1(x,h,f)

  implicit none

  real ( kind = wp ) , intent ( in ) :: x, h
  real ( kind = wp )                 ::  d1_o1, f

  d1_o1 = (f(x+h) - f(x))/h

  end function

! ***********************************************************************

function d1_o2(x,h,f)

implicit none

real ( kind = wp ) , intent ( in ) :: x, h
real ( kind = wp )                 ::  d1_o2, f

d1_o2 = (f(x+h) - f(x-h))/(2._wp*h)

end function

! *********************************************************************

function d1_o4(x,h,f)

implicit none

real ( kind = wp ) , intent ( in ) :: x, h
real ( kind = wp )                 ::  d1_o4, f

d1_o4 =   ((f(x + h) - f(x-h) )* 2._wp/(3._wp) +   &
                   ( f(x-2._wp*h) - f(x+2._wp*h))/(12._wp) )/h

end function


end module derivadas1
