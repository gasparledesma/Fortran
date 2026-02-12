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

    function Probabilidad_00(Gamma_val, hbar, time) result(Prob)
        real(kind=wp), intent(in) :: Gamma_val, hbar, time
        real(kind=wp)             :: Prob
        
        ! P(t) = exp(-2 * Gamma * t / hbar)
        Prob = exp(-2.0_wp * Gamma_val * time / hbar)
        
    end function Probabilidad_00


    !-----------------------------------------------------------------------------------------
    ! Funcion de Green, acoplada a dos cadenas semiinfinitas
    !-----------------------------------------------------------------------------------------

    function Green_00(energy, epsilon_0, sigma_left, sigma_right) result(green)
        real(kind=wp), intent(in)    :: energy, epsilon_0
        complex(kind=wp), intent(in) :: sigma_left, sigma_right
        complex(kind=wp)             :: green  
        
        ! G = 1 / (E - e0 - Sigma_L - Sigma_R)
        green = 1.0_wp / (energy - epsilon_0 - sigma_left - sigma_right)
        
    end function Green_00

    !-----------------------------------------------------------------------------------------
    ! Transmitancia (Formula Fisher-Lee)
    !-----------------------------------------------------------------------------------------
   
    function Transmitancia_00(Gamma_val_left, Gamma_val_right, Green_val) result(trans)
        ! Gamma es Real (viene de la funcion gamma), Green es Complex
        real(kind=wp), intent(in)    :: Gamma_val_left, Gamma_val_right
        complex(kind=wp), intent(in) :: Green_val
        real(kind=wp)                :: trans
        
        ! T = 4 * gamma_L * gamma_R * |G|^2
        ! Usamos abs(Green_val)**2 para obtener el módulo cuadrado correcto
        trans = 4.0_wp * Gamma_val_left * Gamma_val_right * (abs(Green_val)**2)
        
    end function Transmitancia_00

    

end module functions