Program p4

    use ISOprec
    
    implicit none
    !real ( kind = wp ) , dimension (250) :: t , x , der1_o2 , der1_o4
    real ( kind = wp ) :: dx , one_dx , uno_doce , dosterc
    integer :: k , i , nn
    
    
    character(len = 140) :: line
    character(len = 30)  :: inputName
    integer :: fu, stat, dim, ii
    real(kind = wp), dimension(:), allocatable :: t, x
    
    real(kind = wp), dimension(:), allocatable ::  der1_o2 , der1_o4
    
    ! ---------------------------------------------------------------------------------------------------------------
    
    inputName = 'pos.dat'
    dim = 0
      open (newunit = fu, action='read',file = inputName,status='old')
          efermi: do
            read(fu, '(A140)', iostat = stat) line
            if (stat == iostat_end) exit efermi ! end of file
            dim = dim + 1
          end do efermi
    
      close(fu)
    print*,'# of lines', dim
    
    allocate(x(dim), t(dim), der1_o2(dim) , der1_o4(dim))
    
    open (newunit = fu, action='read',file = inputName,status='old')
      do ii = 1, dim
          read(fu, '(A140)') line
          read(line, *) t(ii), x(ii)
    
    !      write(*,*) ii, t(ii), x(ii)
      end do
    
    close(fu)
    
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
    open (newunit=fu , file = './datos/p4-d1o2.dat', status = 'replace')
    write (fu ,*) "#                     t               derivada 1 orden2 "
    
    do k = 1, nn
    
         write (fu,*) t(k) , der1_o2(k)
    !    write (*,*) t(k) , der1_o2(k)
    
    end do
    
    close (fu)
    ! ------------------------------------------------------------------------------------------------------
    
    open (newunit=fu, file = './datos/p4-d1o4.dat', status = 'replace')
    write (fu,*) "#               t                 derivada 1 orden4 "
    
    
    do k = 1, nn
    
             write (fu ,*) t(k) , der1_o4 (k)
    !        write (* ,*) t(k ) , der1_o4 (k)
            
    end do
    
    
    close (fu)
    
    deallocate(x,t,der1_o2,der1_o4)
    
    call execute_command_line ("gnuplot p4.gp", exitstat=i)
      print *, "Exit status of external_prog.exe was ", i
    
    call execute_command_line ("gv ./grafs/p4-datos.eps", exitstat=i)
      print *, "Exit status of external_prog.exe was ", i
    
    call execute_command_line ("gv ./grafs/p4-derivadas.eps", exitstat=i)
      print *, "Exit status of external_prog.exe was ", i
    
    
    
    end program p4
    