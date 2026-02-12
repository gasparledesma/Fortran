program testCubicSpline

use mod_splines
implicit none

! Variables
real(wp), allocatable :: xi(:), yi(:), h, x, y
real(wp), allocatable :: xout(:), yout(:), yp
real(wp)         :: xin, yin
type(spline) :: sp
integer :: i, n, m, numDatos, fu, cuenta, EOF
character(len=40)  ::  arg, fileIn, fileOut, numChar
! ***************************************************

 i = 0
 
 do 
    call get_command_argument(i, arg)
    
    if (i == 1) then
      fileIn  = trim(arg)
      print *, fileIn
    end if  
    
    if (i == 2) then
       fileOut = trim(arg)
       print *, fileOut
    end if
      
    if (i == 3) then
      numChar = trim(arg)
      if (numChar == '') exit
      print*, i, numChar
      read(numChar,*)  numDatos
      print *, numDatos
    end if  
    
    i = i + 1 
    if (i > 3) exit
    
 end do


  if (len_trim(arg) == 0) then
    print *, 'Usage  : testCubicSpline.x fileIn fileOut numInterp'
    print *, '         fileIn : file with data to interpolate.'
    print *, '         fileOut: file to output the interpolate result.'
    print *, '         numInterp : number of point used to interpolate.'
	    stop
  end if
 


cuenta = 0
open(newunit=fu, file=fileIn, status='OLD')
 do
	read(fu, *, iostat = EOF ) xin, yin
	if (EOF == iostat_end) exit
	cuenta = cuenta + 1
 end do
close(fu)

allocate (xi(cuenta), yi(cuenta))
allocate (xout(numDatos), yout(numDatos))

open(newunit=fu, file=fileIn, status='OLD')
 do i = 1, cuenta
	read(fu, *, iostat = EOF ) xi(i), yi(i)
 end do                                 
close(fu)



! ***************************************************
! compile with /fpconstant
!xi = [0.0,0.25,0.5,0.75,1.0,1.25,1.5,1.75,2.0]
!yi = [18.0,18.4921875,18.9375,19.2890625,19.5,19.5234375,19.3125,18.8203125,18.0]

m = size(xi)
!print *, ""

!print '(1x,a6,1x,a18,1x,a18)', "Index", "xin", "yin"

!do i = 1, m
!    print '(1x,i6,1x,g18.11,1x,g18.11)', i, xi(i), yi(i)
!end do

!print *, 'Cubic Spline Interpolation Demo'

h = (xi(size(xi))-xi(1))/(numDatos-1)

sp = spline(xi, yi)

!print *, ""
!print '(1x,a6,1x,a18,1x,a18,1x,a18)', "Index", "x(i)", "y(i)", "x", "y", "yp"

do i = 0, numDatos-1
    x  = xi(1) + i*h
    xout(i+1) = x
    y  = sp%value(x)
    yout(i+1) = y
    yp = sp%slope(x)
!    print '(1x,i6,1x,g18.11,1x,g18.11,1x,g18.11)', i, x, y, yp
end do

!print *, ""

!x = sp%extrema()
!i = sp%indexof(x)
!y = sp%value(x)
!yp = sp%slope(x)

!print *, "Local Extrema"
!print '(1x,a6,1x,a18,1x,a18,1x,a18)', "Index", "x", "y", "yp"
!print '(1x,i6,1x,g18.11,1x,g18.6,1x,g18.6)', i, x, y, yp

open(newunit=fu, file=fileOut)
 do i = 1, numDatos
	write(fu, *) xout(i), yout(i)
 end do                                 
close(fu)

call execute_command_line ("gnuplot LeeCubicSpline.plt", exitstat=i)
  print *, "Exit status of external_prog.exe was ", i

call execute_command_line ("okular datosInter.eps", exitstat=i)
  print *, "Exit status of external_prog.exe was ", i


end program testCubicSpline
