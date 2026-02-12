module func_gen
    use isoprec
    implicit none
    

    real(kind=wp), parameter :: PI = 3.14159265359_wp

    contains

    !-------------------------------------------------------------------------
    ! Delta, Gamma, Sigma analitica
    !-------------------------------------------------------------------------
    function delta(t, epsilon_0)
        real(kind=wp), intent(in) :: t, epsilon_0
        real(kind=wp)             :: delta
        delta = (t - epsilon_0) / 2.0_wp
    end function delta

    function gamma(t, epsilon_0, V_x)
        real(kind=wp), intent(in) :: t, epsilon_0, V_x
        real(kind=wp)             :: gamma, arg
        arg = V_x**2 - ((t - epsilon_0)/2.0_wp)**2
        if (arg > 0.0_wp) then
            gamma = sqrt(arg)
        else
            gamma = 0.0_wp
        end if
    end function gamma

    function sigma1(t, epsilon_0, V_x) result(res)
        real(kind=wp), intent(in) :: t, epsilon_0, V_x
        complex(kind=wp)          :: res
        complex(kind=wp), parameter :: i = (0.0_wp, 1.0_wp)
        res = delta(t, epsilon_0) - i * gamma(t, epsilon_0, V_x)
    end function sigma1

    !-------------------------------------------------------------------------
    ! GENERADOR DE ENERGÍA 
    !-------------------------------------------------------------------------
    ! Si Q=0, devuelve W constante (Homogeneo - Probl 2,3,4)
    ! Si Q≠0, devuelve W*cos(Qn) (Hofstadter - Probl 5)
    
    function obtener_energia_sitio(n, W, Q) result(en)
        integer, intent(in) :: n
        real(kind=wp), intent(in) :: W, Q
        real(kind=wp) :: en
        
        en = W * cos(Q * real(n, kind=wp))
    end function obtener_energia_sitio

    !-------------------------------------------------------------------------
    ! SIGMA RECURSIVA IZQUIERDA 
    !-------------------------------------------------------------------------
    ! Calcula el efecto de los sitios 1 hasta n-1 sobre el sitio n
    function sigma_izquierda_general(n, z, W, Q, V) result(sigma)
        integer, intent(in) :: n
        complex(kind=wp), intent(in) :: z
        real(kind=wp), intent(in) :: W, Q, V  ! W juega el rol de ep0 si Q=0
        complex(kind=wp) :: sigma
        integer :: k
        real(kind=wp) :: e_k

        sigma = (0.0_wp, 0.0_wp)

        ! Si n=1, no hay nadie a la izquierda. Si n>1, iteramos.
        if (n > 1) then
            do k = 1, n-1
                e_k = obtener_energia_sitio(k, W, Q)
                sigma = V**2 / (z - e_k - sigma)
            end do
        end if
    end function sigma_izquierda_general

    !-------------------------------------------------------------------------
    ! SIGMA RECURSIVA DERECHA 
    !-------------------------------------------------------------------------
    ! Calcula el efecto de los sitios N hasta n+1 sobre el sitio n
    function sigma_derecha_general(n, N_total, z, W, Q, V) result(sigma)
        integer, intent(in) :: n, N_total
        complex(kind=wp), intent(in) :: z
        real(kind=wp), intent(in) :: W, Q, V
        complex(kind=wp) :: sigma
        integer :: k
        real(kind=wp) :: e_k

        sigma = (0.0_wp, 0.0_wp)

        ! Si n=N, no hay nadie a la derecha. Si n<N, iteramos hacia atras.
        if (n < N_total) then
            do k = N_total, n+1, -1
                e_k = obtener_energia_sitio(k, W, Q)
                sigma = V**2 / (z - e_k - sigma)
            end do
        end if
    end function sigma_derecha_general

    !-------------------------------------------------------------------------
    ! 5. FUNCIONES DE TRANSMISIÓN Y PROBABILIDAD 
    !-------------------------------------------------------------------------
    function Probabilidad_00(Gamma_val, hbar, time) result(Prob)
        real(kind=wp), intent(in) :: Gamma_val, hbar, time
        real(kind=wp)             :: Prob
        Prob = exp(-2.0_wp * Gamma_val * time / hbar)
    end function Probabilidad_00

function Green_00(z_val, epsilon_0, sigma_left, sigma_right) result(green)
        complex(kind=wp), intent(in) :: z_val            
        real(kind=wp), intent(in)    :: epsilon_0        
        complex(kind=wp), intent(in) :: sigma_left, sigma_right
        complex(kind=wp)             :: green  
        
        green = 1.0_wp / (z_val - epsilon_0 - sigma_left - sigma_right)
    end function Green_00

    function Transmitancia_00(Gamma_val_left, Gamma_val_right, Green_val) result(trans)
        real(kind=wp), intent(in)    :: Gamma_val_left, Gamma_val_right
        complex(kind=wp), intent(in) :: Green_val
        real(kind=wp)                :: trans
        trans = 4.0_wp * Gamma_val_left * Gamma_val_right * (abs(Green_val)**2)
    end function Transmitancia_00

end module func_gen