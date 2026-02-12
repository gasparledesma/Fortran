program intento
    use, intrinsic :: iso_fortran_env, only: real32, real64, real128
    implicit none

    ! Tipos de precisión
    integer, parameter :: dp = real128  ! podemos usar "dp" para comodidad

    ! Variables
    complex(kind=dp) :: sigma_val
    complex(kind=dp) :: G_val
    real(kind=dp)    :: tiempo_ini, tiempo_fin, V, epsilon0, t
    integer          :: n, nmax

    ! Parámetros del sistema
    epsilon0 = 0.1_dp
    V        = 1.0_dp
    nmax     = 100000

    write(*,*) 'nmax =', nmax

    call cpu_time(tiempo_ini)

    t = 0.5_dp  ! ejemplo de tiempo

    ! Calcular sigma_iter
    sigma_val = sigma_iter(t, nmax, epsilon0, V)

    ! Calcular Green
    G_val = 1.0_dp / ( t - epsilon0 - sigma_val - suma(t, epsilon0, V) )

    call cpu_time(tiempo_fin)
    write(*,*) 'Tiempo de ejecución:', tiempo_fin - tiempo_ini
    write(*,*) 'Green(t) =', G_val

contains

    recursive function sigma_iter(t, nmax, epsilon0, V) result(sigma)
        implicit none
        integer, intent(in) :: nmax
        real(kind=dp), intent(in) :: t, epsilon0, V
        complex(kind=dp) :: sigma
        integer :: n

        sigma = (0.0_dp, 0.0_dp)
        do n = 1, nmax
            sigma = V**2 / (t - epsilon0 - sigma)
        end do
    end function sigma_iter

    function suma(t, epsilon0, V) result(s)
        implicit none
        real(kind=dp), intent(in) :: t, epsilon0, V
        complex(kind=dp) :: s
        s = ( (t - epsilon0)/2.0_dp + sqrt( ((t - epsilon0)/2.0_dp)**2 - V**2 ), 0.0_dp )
    end function suma

end program intento
