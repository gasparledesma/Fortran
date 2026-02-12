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
    ! Funciones de ramas reales (Positiva y Negativa)
    !-----------------------------------------------------------------------------------------
    function sigma_pos(t, epsilon_0, V_x)
        real(kind=wp), intent(in) :: t, epsilon_0, V_x
        real(kind=wp)             :: sigma_pos
        real(kind=wp)             :: rad

        ! Calculamos la raiz (asumiendo que llamamos a esta funcion FUERA de la banda)
        ! Abs asegura que no de error si por redondeo estamos justo en el borde
        rad = sqrt(abs(((t - epsilon_0)/2.0_wp)**2 - V_x**2))

        sigma_pos = (t - epsilon_0)/2.0_wp + rad
    end function sigma_pos

    function sigma_neg(t, epsilon_0, V_x)
        real(kind=wp), intent(in) :: t, epsilon_0, V_x
        real(kind=wp)             :: sigma_neg
        real(kind=wp)             :: rad

        rad = sqrt(abs(((t - epsilon_0)/2.0_wp)**2 - V_x**2))

        sigma_neg = (t - epsilon_0)/2.0_wp - rad
    end function sigma_neg


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




end module functions