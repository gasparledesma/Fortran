module derivadas1


    use ISOprec
    
    
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
    
    !----------------------------------------------------------------------------------------------------------

nn = dim
dx = t(2)-t(1)
one_dx = 1._wp/dx

! orden 2 -------------------------------------------------------------------------------------------------

der1_o2(1) = (-1.5_wp*x (1) + 2._wp *x (1 + 1) - 0.5_wp *x (2 + 1) )* one_dx

der1_o2(2:nn-1) = (x(3:nn ) - x(1:nn-2) ) * 0.5_wp * one_dx

der1_o2(nn) = (1.5_wp * x(nn) - 2._wp *x(-1 + nn) + 0.5_wp * x(-2 + nn)) * one_dx


! orden 4 -----------------------------------------------------------------------------------------------

uno_doce = 1._wp/12._wp
dosterc = 2._wp/3._wp
der1_o4(1) = (-25._wp *x(1) + 48._wp *x (1 + 1) - 36._wp *x (1 + 2)      &
       &             +16._wp * x(1+3) -3._wp *x (1 + 4) ) * one_dx * uno_doce

!write (*,*) "der1_o4(1) = ", der1_o4(1)

der1_o4 (1+1) = (- 3._wp *x (1) -10._wp *x (1 + 1) +18._wp * x (1 + 2)    &
       &               - 6. _wp *x (1+3) + x (1 + 4) )* one_dx * uno_doce
       
!write (*,'(A,2X,E23.15)') "der1_o4(2) = ", der1_o4(2)


der1_o4 (3:nn-2) = (( x (1:nn-4) -x (5: nn ))* uno_doce + ( x (4:nn-1) -x (2: nn-3) )* dosterc )* one_dx

!write (*,10) "der1_o4(3:12) = ", der1_o4(3:10)

!write (*,10) "der1_o4(13:22) = ", der1_o4(10:20)

!10 format(A15,10(1X, E20.14))

der1_o4 ( nn -1) = ( 3._wp *x ( nn ) +10._wp *x( nn -1)-18._wp *x (nn-2) &
                   &       + 6._wp *x(nn-3) - x( nn-4) )* one_dx * uno_doce
                   
!write (*,*) "der1_o4(3) = ", der1_o4(3)                  

der1_o4 ( nn ) =   (25._wp *x( nn ) - 48._wp *x( nn - 1) + 36._wp *x( nn - 2) &
                    &      -16._wp *x( nn - 3) + 3._wp *x( nn - 4) )* one_dx * uno_doce

!write (*,*) "der1_o4(4) = ", der1_o4(4)

!-------------------------------------------------------------------------------------------------------
    
    end module derivadas1
    