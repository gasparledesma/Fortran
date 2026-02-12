program problema3_ab_comparacion
    use isoprec
    use functions
    implicit none

    ! --- VARIABLES ---
    integer, parameter :: N_time = 1000
    integer, parameter :: N_energy = 2000
    integer :: k
    
    ! Variables Físicas
    real(kind=wp) :: ep0  = 0.0_wp    
    real(kind=wp) :: V    = 1.0_wp    
    real(kind=wp) :: hbar = 1.0_wp 
    
    ! Variables de Gammas
    real(kind=wp) :: E_resonancia = 0.0_wp
    real(kind=wp) :: Gamma_single  ! Para inciso A (1 lead)
    real(kind=wp) :: Gamma_double  ! Para inciso B (2 leads)

    ! Variables para Bucles
    real(kind=wp) :: time, dt, t_max
    real(kind=wp) :: prob_A, prob_B
    real(kind=wp) :: E, dE, E_min, E_max
    real(kind=wp) :: ldos_A, ldos_B

    ! Crear carpetas
    call execute_command_line("mkdir datos", exitstat=k) 
    call execute_command_line("mkdir graficos", exitstat=k)

    ! =========================================================================
    ! 1. CONFIGURACIÓN DE GAMMAS
    ! =========================================================================
    
    ! Caso A: Un solo cable semi-infinito
    Gamma_single = gamma(E_resonancia, ep0, V)
    
    ! Caso B: Dos cables (Izquierda + Derecha)
    ! Como son identicos: Gamma_total = Gamma_L + Gamma_R = 2 * Gamma_single
    Gamma_double = 2.0_wp * Gamma_single
    
    print *, "--- PARAMETROS WBL ---"
    print *, "Gamma Inciso A (1 lead) : ", Gamma_single
    print *, "Gamma Inciso B (2 leads): ", Gamma_double

    ! =========================================================================
    ! 2. PROBABILIDAD P(t) (Inciso A vs B)
    ! =========================================================================
    open(10, file='datos/comparacion_probabilidad.dat')
    write(10, *) "# Tiempo      Prob_A(1lead)    Prob_B(2leads)"

    ! Definimos t_max basado en el decaimiento mas lento (caso A)
    t_max = 5.0_wp / Gamma_single  
    dt = t_max / real(N_time, kind=wp)

    do k = 0, N_time
        time = real(k, kind=wp) * dt
        
        ! Calculamos ambas probabilidades
        prob_A = Probabilidad_00(Gamma_single, hbar, time)
        prob_B = Probabilidad_00(Gamma_double, hbar, time)
        
        ! Guardamos en columnas separadas
        write(10, *) time, prob_A, prob_B
    end do
    close(10)
    print *, "Generado: datos/comparacion_probabilidad.dat"

    ! =========================================================================
    ! 3. LDOS (Inciso A vs B)
    ! =========================================================================
    open(20, file='datos/comparacion_ldos.dat')
    write(20, *) "# Energia     LDOS_A(1lead)    LDOS_B(2leads)"
    
    E_min = -5.0_wp
    E_max = 5.0_wp
    dE = (E_max - E_min) / real(N_energy, kind=wp)

    do k = 0, N_energy
        E = E_min + real(k, kind=wp) * dE
        
        ! Calculamos ambas LDOS
        ldos_A = ldos_00_wbl(E, ep0, Gamma_single)
        ldos_B = ldos_00_wbl(E, ep0, Gamma_double)

        write(20, *) E, ldos_A, ldos_B
    end do
    close(20)
    print *, "Generado: datos/comparacion_ldos.dat"

end program problema3_ab_comparacion