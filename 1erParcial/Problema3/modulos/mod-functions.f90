module functions
    use isoprec
    implicit none

    contains

    !-----------------------------------------------------------------------------------------
    function delta(t, epsilon_0)
        real(kind=wp), intent(in) :: t, epsilon_0
        real(kind=wp)             :: delta

        delta = (t - epsilon_0) / 2.0_wp
    end function delta


    !-----------------------------------------------------------------------------------------
    function gamma(t, epsilon_0, V_x)
        real(kind=wp), intent(in) :: t, epsilon_0, V_x
        real(kind=wp)             :: gamma
        real(kind=wp)             :: arg

        ! Calculamos el argumento primero para seguridad
        arg = V_x**2 - ((t - epsilon_0)/2.0_wp)**2

        ! Si es negativo (fuera de banda), gamma es 0 para evitar NaN en reales
        if (arg > 0.0_wp) then
            gamma = sqrt(arg)
        else
            gamma = 0.0_wp
        end if
    end function gamma

    !-----------------------------------------------------------------------------------------
    ! Función Sigma1 (Compleja)
    !-----------------------------------------------------------------------------------------
    function sigma1(t, epsilon_0, V_x) result(res)
        real(kind=wp), intent(in) :: t, epsilon_0, V_x
        complex(kind=wp)          :: res
        complex(kind=wp), parameter :: i = (0.0_wp, 1.0_wp)

        ! Nota: Gamma ya devuelve 0 si está fuera de banda, así que esto es seguro
        res = delta(t, epsilon_0) - i * gamma(t, epsilon_0, V_x)
    end function sigma1


    !-----------------------------------------------------------------------------------------
    ! Función Recursiva para Sigma Izquierda (Fracción Continua)
    !-----------------------------------------------------------------------------------------
    function calcular_sigma_izquierda(n, z_val, e0_val, V_val) result(sigma)
        integer, intent(in) :: n
        complex(kind=wp), intent(in) :: z_val
        real(kind=wp), intent(in) :: e0_val, V_val
        complex(kind=wp) :: sigma
        integer :: i
        
        ! Base: Si n=0 (Superficie), no hay nada a la izquierda.
        sigma = (0.0_wp, 0.0_wp)
        
        ! Recurrencia: Sigma_n = V^2 / (z - E0 - Sigma_{n-1})
        if (n > 0) then
            do i = 1, n
                sigma = V_val**2 / (z_val - e0_val - sigma)
            end do
        end if
        
    end function calcular_sigma_izquierda

    !-----------------------------------------------------------------------------------------
    ! Densidad de Estados/Funcion de Green
    !-----------------------------------------------------------------------------------------
    
    !-------------------------------------------------------------------------
    ! Densidad de Estados (LDOS) en BANDA ANCHA (WBL)
    !-------------------------------------------------------------------------
    ! CORRECCION: Le pasamos Gamma_constante como argumento porque es WBL.
    ! La variable es 'E_val' (la energía que recorre el bucle).
    
    function ldos_00_wbl(E_val, epsilon_0, Gamma_val) result(ldos)
        real(kind=wp), intent(in) :: E_val       ! Energia variable
        real(kind=wp), intent(in) :: epsilon_0   ! Centro
        real(kind=wp), intent(in) :: Gamma_val   ! Ancho constante
        real(kind=wp)             :: ldos
        
        complex(kind=wp) :: Green
        complex(kind=wp), parameter :: i = (0.0_wp, 1.0_wp)
        real(kind=wp), parameter :: pi = 3.14159265359_wp

        ! Formula de Green con Self-Energy constante (-i * Gamma)
        ! G(E) = 1 / (E - e0 + i*Gamma)
        Green = 1.0_wp / (E_val - epsilon_0 + i * Gamma_val)
        
        ldos = -1.0_wp/pi * aimag(Green)

    end function ldos_00_wbl





    !-----------------------------------------------------------------------------------------
    ! Probabilidad de Supervivencia P(t) = exp(-2 * Gamma * t / hbar)
    !-----------------------------------------------------------------------------------------
    !function Probabilidad_00(Energy_res, epsilon_0, V_x, hbar, time) result(Prob)
    !    real(kind=wp), intent(in) :: Energy_res  ! Energia donde evaluamos Gamma
    !    real(kind=wp), intent(in) :: epsilon_0, V_x, hbar, time
    !    real(kind=wp)             :: Prob
    !    
    !    ! Calculamos el Gamma fijo a la energía de resonancia
    !    ! Recordar: Tu funcion gamma devuelve 0 si esta fuera de banda.
    !    real(kind=wp) :: Gamma_val
    !    
    !    Gamma_val = gamma(Energy_res, epsilon_0, V_x)
    !    
    !    ! Formula del decaimiento exponencial
    !    Prob = exp(-2.0_wp * Gamma_val * time / hbar)
    !    
    !end function Probabilidad_00

    function Probabilidad_00(Gamma_val, hbar, time) result(Prob)
        real(kind=wp), intent(in) :: Gamma_val, hbar, time
        real(kind=wp)             :: Prob
        
        ! P(t) = exp(-2 * Gamma * t / hbar)
        Prob = exp(-2.0_wp * Gamma_val * time / hbar)
        
    end function Probabilidad_00

end module functions