program intento
    use, intrinsic :: iso_fortran_env, only: real128
    implicit none

    integer, parameter :: dp = real128
    complex(kind=dp) :: sigma_val, G_val
    real(kind=dp) :: tiempo_ini, tiempo_fin, V, epsilon0, t
    integer :: nmax, i, Npoints
    real(kind=dp) :: tmin, tmax, dt

    open(unit=10, file='Green_spectrum.dat', status='replace', action='write')

    ! Parámetros del sistema
    epsilon0 = 0.1_dp
    V        = 1.0_dp
    nmax     = 3
    Npoints  = 500        ! cantidad de puntos para t
    tmin     = -1.0_dp
    tmax     = 2.0_dp
    dt       = (tmax - tmin)/real(Npoints-1,dp)

    call cpu_time(tiempo_ini)

    do i = 0, Npoints-1
        t = tmin + i*dt

        ! calcular sigma_iter
        sigma_val = sigma_iter(t, nmax, epsilon0, V)

        ! calcular Green
        G_val = 1.0_dp / ( t - epsilon0 - sigma_val - suma(t, epsilon0, V) )

        ! guardar en archivo: t vs (1/pi)*imag(G)
        write(10,'(2E25.15)') t, aimag(G_val)/acos(-1.0_dp)
    end do

    call cpu_time(tiempo_fin)
    write(*,*) 'Tiempo de ejecución:', tiempo_fin - tiempo_ini

    close(10)
    write(*,*) 'Archivo Green_spectrum.dat generado.'

contains

    recursive function sigma_iter(t, nmax, epsilon0, V) result(sigma)
        implicit none
        integer, intent(in) :: nmax
        real(kind=dp), intent(in) :: t, epsilon0, V
        complex(kind=dp) :: sigma
        integer :: n

        sigma = cmplx(0.0_dp, 0.0_dp, kind=dp)
        do n = 1, nmax
            sigma = V**2 / ( t - epsilon0 - sigma )
        end do
    end function sigma_iter

    function suma(t, epsilon0, V) result(s)
        implicit none
        real(kind=dp), intent(in) :: t, epsilon0, V
        complex(kind=dp) :: s

        s = cmplx( (t - epsilon0)/2.0_dp + sqrt( ((t - epsilon0)/2.0_dp)**2 - V**2 ), 0.0_dp, kind=dp )
    end function suma

end program intento
