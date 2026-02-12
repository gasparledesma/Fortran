program problema5_formula_recursiva_autom
    use isoprec
    use functions
    implicit none

    ! --- 1. CONFIGURACIÓN ALTA RESOLUCIÓN ---
    integer, parameter :: N_energy = 4000
    integer, parameter :: N_total  = 100 
    
    integer :: k, stat
    integer :: i_q, i_w  ! Indices para bucles
    
    ! Parametros Fisicos
    real(kind=wp) :: V = 1.0_wp 
    real(kind=wp) :: a = 1.0_wp
    
    ! Arrays de Parametros (Igual que en Matrices)
    real(kind=wp), dimension(3) :: W_list = (/ 0.5_wp, 2.0_wp, 3.0_wp /)
    real(kind=wp), dimension(2) :: Q_list
    
    real(kind=wp) :: W_act, Q_act

    ! Cables (Leads)
    real(kind=wp) :: ep_lead = 0.0_wp    
    real(kind=wp) :: V_L = 0.5_wp        
    real(kind=wp) :: V_R = 0.5_wp

    ! Energia y ETA (Friccion BAJA para N=100)
    real(kind=wp) :: E, dE, E_min, E_max
    real(kind=wp) :: eta = 0.0001_wp     
    
    complex(kind=wp) :: z

    ! Variables de Calculo
    complex(kind=wp) :: Sig_Cable_L, Sig_Cable_R
    complex(kind=wp) :: G_1N_val
    real(kind=wp)    :: Gam_L_lead, Gam_R_lead
    
    ! Matriz de Resultados
    real(kind=wp) :: res_Trans(2, 3)
    
    character(len=64) :: filename

    ! Output
    call execute_command_line("mkdir datos", exitstat=stat) 
    
    ! Nombre genérico porque contiene TODOS los casos
    write(filename, '("datos/Trans_Recursiva_Todos.dat")')
    open(20, file=filename, status='replace')
    
    ! Encabezado
    write(20, '(A)', advance='no') "# E  "
    do i_q = 1, 2
        do i_w = 1, 3
            ! Mantenemos estructura (DOS, Trans) aunque DOS sea 0.0
            write(20, '(A,I1,A,I1, A,I1,A,I1)', advance='no') &
                  " ZERO", i_q, "W", i_w, "  T_Q", i_q, "W", i_w
        end do
    end do
    write(20, *) "" 

    ! Definir valores de Q
    Q_list(1) = 2.0_wp / a 
    Q_list(2) = 2.0_wp * 3.14159265359_wp / (3.0_wp * a)

    E_min = -4.5_wp
    E_max = 4.5_wp
    dE = (E_max - E_min) / real(N_energy, kind=wp)

    print *, "Calculando Recursivo (N=100, eta=0.0001)..."

    ! === BUCLE DE ENERGÍA ===
    do k = 0, N_energy
        E = E_min + real(k, kind=wp) * dE
        z = cmplx(E, eta, kind=wp)

        ! 1. Propiedades de los CABLES 
        Sig_Cable_L = (V_L/V)**2 * sigma1(E, ep_lead, V)
        Sig_Cable_R = (V_R/V)**2 * sigma1(E, ep_lead, V)
        
        Gam_L_lead = -aimag(Sig_Cable_L)
        Gam_R_lead = -aimag(Sig_Cable_R)

        ! 2. BUCLE SOBRE PARAMETROS
        do i_q = 1, 2
            do i_w = 1, 3
                
                Q_act = Q_list(i_q)
                W_act = W_list(i_w)

                ! Llamada al modulo functions (Recursivo)
                G_1N_val = get_G1N_Hof(z, W_act, Q_act, V, N_total, Sig_Cable_L, Sig_Cable_R)

                ! Formula Fisher-Lee
                ! GUARDAMOS en la matriz res_Trans
                res_Trans(i_q, i_w) = 4.0_wp * Gam_L_lead * Gam_R_lead * (abs(G_1N_val)**2)
            end do
        end do
        
        ! 3. ESCRITURA COMPATIBLE
        ! Escribimos 0.0_wp en lugar de DOS para mantener las columnas alineadas
        ! Formato: E, (0.0, Trans), (0.0, Trans)...
        write(20, '(13ES16.7)') E, &
             ((0.0_wp, res_Trans(i_q, i_w), i_w=1,3), i_q=1,2)
             
    end do
    
    close(20)
    print *, "Archivo generado: ", filename
    print *, "Nota: Las columnas de DOS estan en 0.0. Solo graficar Transmision."

end program problema5_formula_recursiva_autom