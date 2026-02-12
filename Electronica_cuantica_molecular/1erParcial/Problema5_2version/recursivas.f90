program problema5_formula_recursiva
    use isoprec
    use functions
    implicit none

    ! --- 1. CONFIGURACIÓN DE ALTA RESOLUCIÓN ---
    ! Igualamos los parametros al metodo de matrices
    integer, parameter :: N_energy = 4000    ! 4000 Puntos
    integer, parameter :: N_total  = 100     ! Cadena larga
    
    integer :: k, stat
    
    ! Parametros Fisicos
    real(kind=wp) :: V = 1.0_wp 
    
    real(kind=wp), dimension(3) :: W_list = (/ 0.5_wp, 2.0_wp, 3.0_wp /)
    real(kind=wp), dimension(2) :: Q_listp
    
    real(kind=wp) :: W_act, Q_act
    ! Cables (Leads) - Acople Debil
    real(kind=wp) :: ep_lead = 0.0_wp    
    real(kind=wp) :: V_L = 0.5_wp        
    real(kind=wp) :: V_R = 0.5_wp

    ! Energia y ETA (Friccion)
    real(kind=wp) :: E, dE, E_min, E_max
    
    ! --- CAMBIO CLAVE: ETA MUY BAJO PARA N=100 ---
    real(kind=wp) :: eta = 0.0001_wp     
    
    complex(kind=wp) :: z

    ! Variables de Calculo
    complex(kind=wp) :: Sig_Cable_L, Sig_Cable_R
    complex(kind=wp) :: G_1N_val
    real(kind=wp)    :: Gam_L_lead, Gam_R_lead
    real(kind=wp)    :: Transmision_T
    
    character(len=64) :: filename

    ! Output
    call execute_command_line("mkdir datos", exitstat=stat) 
    
    ! Nombre del archivo automatico segun W
    write(filename, '("datos/Trans_Recursiva_W", F3.1, ".dat")') W
    open(20, file=filename, status='replace')
    write(20, *) "# Energia   Transmision"
    print *, "Calculando Recursivo (N=100, eta=0.0001): ", filename

    ! Configuración Q = 2/a
    Q = 2.0_wp / a 
    
    E_min = -4.5_wp
    E_max = 4.5_wp
    dE = (E_max - E_min) / real(N_energy, kind=wp)

    ! === BUCLE DE ENERGÍA ===
    do k = 0, N_energy
        E = E_min + real(k, kind=wp) * dE
        z = cmplx(E, eta, kind=wp)

        ! 1. Propiedades de los CABLES (Escalados por el acople)
        Sig_Cable_L = (V_L/V)**2 * sigma1(E, ep_lead, V)
        Sig_Cable_R = (V_R/V)**2 * sigma1(E, ep_lead, V)
        
        Gam_L_lead = -aimag(Sig_Cable_L)
        Gam_R_lead = -aimag(Sig_Cable_R)

        ! 2. Propagador G_1N (De punta a punta) - Metodo Recursivo
        !    Asegurate que tu modulo functions tenga la funcion 'get_G1N_Hof'
        G_1N_val = get_G1N_Hof(z, W, Q, V, N_total, Sig_Cable_L, Sig_Cable_R)

        ! 3. Formula Fisher-Lee
        Transmision_T = 4.0_wp * Gam_L_lead * Gam_R_lead * (abs(G_1N_val)**2)

        ! 4. Escritura con Notacion Cientifica (Para evitar ceros falsos)
        write(20, '(2ES20.10)') E, Transmision_T
    end do
    
    close(20)
    print *, "Finalizado."

end program problema5_formula_recursiva