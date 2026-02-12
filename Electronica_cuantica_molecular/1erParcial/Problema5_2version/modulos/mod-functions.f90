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


    !-------------------------------------------------------------------------
    ! Densidad de Estados (LDOS) en BANDA ANCHA (WBL)
    !-------------------------------------------------------------------------
    
    function ldos_00_wbl(E_val, epsilon_0, Gamma_val) result(ldos)
        real(kind=wp), intent(in) :: E_val       ! Energia variable
        real(kind=wp), intent(in) :: epsilon_0   ! Centro
        real(kind=wp), intent(in) :: Gamma_val   ! Ancho constante
        real(kind=wp)             :: ldos
        
        complex(kind=wp) :: Green
        complex(kind=wp), parameter :: i = (0.0_wp, 1.0_wp)
        real(kind=wp), parameter :: pi = 3.14159265359_wp

        ! Formula de Green con Self-Energy constante (-i * Gamma)
    
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

    
    ! =========================================================================
    ! CADENA INHOMOGENEA
    ! =========================================================================

    ! Modelo de Hofstadter
    ! ---------------------------------------------------------------------

    function e_Hofstadter(n, W, Q_val) result(en)
        integer, intent(in) :: n
        real(kind=wp), intent(in) :: W, Q_val
        real(kind=wp) :: en

        ! eps_n = W * cos(Q * n * a)
        ! tomamos a = 1.0 pero es porque Q ya incluye "a" entonces se van a cancelar.

        en = W * cos(Q_val * real(n, kind=wp))
    end function e_Hofstadter


    ! Sigma Izquierda
    ! ---------------------------------------------------------------------
    function sigma_izquierda_Hof(n, z, W, Q, V) result(sigma)
        integer, intent(in) :: n
        complex(kind=wp), intent(in) :: z  
        real(kind=wp), intent(in) :: W, Q, V
        complex(kind=wp) :: sigma
        integer :: k
        real(kind=wp) :: e_k

        ! Empezamos desde la superficie izquierda (sitio 0 o pared) -> Sigma=0
        sigma = (0.0_wp, 0.0_wp)

        if (n > 1) then
            do k = 1, n-1
                e_k = e_Hofstadter(k, W, Q)
                sigma = V**2 / (z - e_k - sigma)
            end do
        end if
    end function sigma_izquierda_Hof


    ! Sigma Derecha (Efecto de sitios N...n+1 sobre el sitio n)
    ! ---------------------------------------------------------------------

    function sigma_derecha_Hof(n, N_total, z, W, Q, V) result(sigma)
        integer, intent(in) :: n, N_total
        complex(kind=wp), intent(in) :: z     
        real(kind=wp), intent(in) :: W, Q, V
        complex(kind=wp) :: sigma
        integer :: k
        real(kind=wp) :: e_k

        sigma = (0.0_wp, 0.0_wp)
        
        !!!!!!!!!! Si n=N, no hay nadie a la derecha, retorna 0.
        !!!!!!!!!! Si n<N, acumulamos el efecto desde el sitio N hacia atras hasta n+1

        if (n < N_total) then
            ! Bucle inverso desde N hasta n+1
            do k = N_total, n+1, -1
                e_k = e_Hofstadter(k, W, Q)
                sigma = V**2 / (z - e_k - sigma)
            end do
        end if
    end function sigma_derecha_Hof

    function Green_nn_Hof(z_val, epsilon_sitio, sigma_left, sigma_right) result(green_Hof)
        complex(kind=wp), intent(in) :: z_val          
        real(kind=wp), intent(in)    :: epsilon_sitio
        complex(kind=wp), intent(in) :: sigma_left, sigma_right
        complex(kind=wp)             :: green_Hof  
        
        green_Hof = 1.0_wp / (z_val - epsilon_sitio - sigma_left - sigma_right)
    end function Green_nn_Hof

    ! ------------------------------------------------------------------------
    ! NUEVA: Sigma Izquierda que incluye el cable (Para Transmisión)
    ! ------------------------------------------------------------------------
    ! Calcula la Sigma efectiva en el sitio 'n' acumulando todo lo de atras
    ! INCLUYENDO la sigma del cable inicial (sigma_init).
    
    function sigma_izquierda_con_init(n, z, W, Q, V, sigma_init) result(sigma)
        integer, intent(in) :: n
        complex(kind=wp), intent(in) :: z 
        real(kind=wp), intent(in) :: W, Q, V
        complex(kind=wp), intent(in) :: sigma_init  ! <--- El cable izquierdo
        complex(kind=wp) :: sigma
        integer :: k
        real(kind=wp) :: e_k

        ! En el sitio 1 (borde), la "sigma anterior" no es 0, es el CABLE.
        sigma = sigma_init

        ! Si n > 1, empezamos a iterar la cadena de Hofstadter
        if (n > 1) then
            do k = 1, n-1
                e_k = e_Hofstadter(k, W, Q)
                sigma = V**2 / (z - e_k - sigma)
            end do
        end if
    end function sigma_izquierda_con_init


! ------------------------------------------------------------------------
    ! Calcular G_{1,N} (Propagador de extremo a extremo)
    ! ------------------------------------------------------------------------
    function get_G1N_Hof(z, W, Q, V, N_total, Sig_Cable_L, Sig_Cable_R) result(g1n)
        complex(kind=wp), intent(in) :: z, Sig_Cable_L, Sig_Cable_R
        real(kind=wp), intent(in)    :: W, Q, V
        integer, intent(in)          :: N_total
        complex(kind=wp)             :: g1n
        
        ! Variables auxiliares
        complex(kind=wp) :: Sig_L_acumulada, g_local_izq, producto_propagadores
        complex(kind=wp) :: G_NN_total
        real(kind=wp)    :: ep_k
        integer          :: k

        ! 1. Calculamos el producto de propagadores desde el sitio 1 hasta N-1
        !    Formula: Prod = Prod * (V / (z - ek - Sigma_anterior))
        
        producto_propagadores = (1.0_wp, 0.0_wp) ! Inicializamos en 1
        Sig_L_acumulada       = Sig_Cable_L      ! En el sitio 1, la sigma izq es el cable

        do k = 1, N_total - 1
            ep_k = e_Hofstadter(k, W, Q)
            
            ! Green del sitio k "mirando solo a la izquierda"
            g_local_izq = 1.0_wp / (z - ep_k - Sig_L_acumulada)
            
            ! Acumulamos el salto V hacia adelante
            producto_propagadores = producto_propagadores * (V * g_local_izq)
            
            ! Actualizamos la Sigma para el siguiente sitio
            Sig_L_acumulada = V**2 * g_local_izq
        end do

        ! 2. Ahora necesitamos G_NN Total (Sitio N con todo conectado)
        !    Ya tenemos Sig_L_acumulada que llega hasta N
        ep_k = e_Hofstadter(N_total, W, Q)
        
        G_NN_total = 1.0_wp / (z - ep_k - Sig_L_acumulada - Sig_Cable_R)
        
        ! 3. Resultado final: G1N = G_NN * Producto
        g1n = G_NN_total * producto_propagadores

    end function get_G1N_Hof

end module functions