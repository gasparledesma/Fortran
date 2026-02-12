program problema5ab_hofstadter_autom
    use isoprec
    use functions
    implicit none

    ! --- 1. DECLARACIONES ---
    integer, parameter :: N_energy = 4000
    integer, parameter :: N_total = 100 
    integer :: k, stat, n_sitio
    integer :: i_q, i_w  ! Indices para los bucles de parametros
    
    ! Parametros Fisicos
    real(kind=wp) :: V = 1.0_wp 
    real(kind=wp) :: a = 1.0_wp
    
    ! --- ARRAYS DE PARAMETROS ---
    ! Definimos los valores de W y Q en listas (arrays)
    real(kind=wp), dimension(3) :: W_list = (/ 0.5_wp, 2.0_wp, 3.0_wp /)
    real(kind=wp), dimension(2) :: Q_list
    
    ! Variables temporales para el bucle
    real(kind=wp) :: W_act, Q_act

    ! Parametros de los Cables
    real(kind=wp) :: ep_lead = 0.0_wp    
    real(kind=wp) :: V_L = 0.5_wp        
    real(kind=wp) :: V_R = 0.5_wp        

    ! Variables de Energia
    real(kind=wp) :: E, dE, E_min, E_max, eta = 0.0001_wp
    complex(kind=wp) :: z

    ! Variables Auxiliares Green / Sigma
    complex(kind=wp) :: Sig_L, Sig_R, G_nn
    complex(kind=wp) :: Sig_Cable_L, Sig_Cable_R, Sig_Cadena_Acumulada
    real(kind=wp)    :: ep_n
    real(kind=wp)    :: Gam_L_eff, Gam_R_phys

    ! --- MATRICES DE RESULTADOS ---
    ! Guardaremos: result_DOS(Q, W) y result_Trans(Q, W)
    ! Dimensiones: (2 casos de Q, 3 casos de W)
    real(kind=wp) :: res_DOS(2, 3)
    real(kind=wp) :: res_Trans(2, 3)
    real(kind=wp) :: dens_acumulada

    ! --- CONFIGURACION ---
    call execute_command_line("mkdir datos", exitstat=stat) 
    
    open(20, file='datos/todos_los_datos.dat')
    
    ! Escribimos un encabezado explicativo (13 columnas en total)
    ! Col 1: Energia
    ! Cols siguientes: Pares de (DOS, Trans) para cada caso
   
    write(20, '(A)', advance='no') "# E  "
    
    do i_q = 1, 2
        do i_w = 1, 3
            ! Formato corregido: 4 pares de (Texto, Entero)
            write(20, '(A,I1,A,I1, A,I1,A,I1)', advance='no') &
                  " DOS_Q", i_q, "W", i_w, "  T_Q", i_q, "W", i_w
        end do
    end do
    write(20, *) "" ! Salto de linea final del encabezado

    ! Definir valores de Q
    Q_list(1) = 2.0_wp / a 
    Q_list(2) = 2.0_wp * 3.14159265359_wp / (3.0_wp * a)

    E_min = -4.0_wp
    E_max = 4.0_wp
    dE = (E_max - E_min) / real(N_energy, kind=wp)

    ! === BUCLE DE ENERGÍA ===
    print *, "Calculando... Por favor espere."
    
    do k = 0, N_energy
        E = E_min + real(k, kind=wp) * dE
        z = cmplx(E, eta, kind=wp)

        ! Calculamos Sigmas de los cables (solo dependen de E)
        Sig_Cable_L = (V_L/V)**2 * sigma1(E, ep_lead, V)
        Sig_Cable_R = (V_R/V)**2 * sigma1(E, ep_lead, V)
        Gam_R_phys  = -aimag(Sig_Cable_R)

        ! --- BUCLES SOBRE PARAMETROS (Q y W) ---
        do i_q = 1, 2
            do i_w = 1, 3
                
                ! Parametros actuales
                Q_act = Q_list(i_q)
                W_act = W_list(i_w)

                ! 1. CALCULO DE DOS (Suma sobre sitios)
                ! -------------------------------------
                dens_acumulada = 0.0_wp
                do n_sitio = 1, N_total
                    ep_n  = e_Hofstadter(n_sitio, W_act, Q_act)
                    Sig_L = sigma_izquierda_Hof(n_sitio, z, W_act, Q_act, V)
                    Sig_R = sigma_derecha_Hof(n_sitio, N_total, z, W_act, Q_act, V)
                    
                    G_nn  = Green_nn_Hof(z, ep_n, Sig_L, Sig_R)
                    dens_acumulada = dens_acumulada + (-1.0_wp/3.14159265359_wp)*aimag(G_nn)
                end do
                res_DOS(i_q, i_w) = dens_acumulada

                ! 2. CALCULO DE TRANSMISION (Global)
                ! ----------------------------------
                ! Arrastramos cable izq hasta el final
                Sig_Cadena_Acumulada = sigma_izquierda_con_init(N_total, z, W_act, Q_act, V, Sig_Cable_L)
                
                ep_n = e_Hofstadter(N_total, W_act, Q_act)
                G_nn = 1.0_wp / (z - ep_n - Sig_Cadena_Acumulada - Sig_Cable_R)
                
                Gam_L_eff = -aimag(Sig_Cadena_Acumulada)
                
                res_Trans(i_q, i_w) = 4.0_wp * Gam_L_eff * Gam_R_phys * (abs(G_nn)**2)

            end do
        end do

        ! --- ESCRITURA EN ARCHIVO (Una linea por energia) ---
        ! Formato: E, luego iteramos los arrays
        write(20, '(13ES16.7)') E, &
             ((res_DOS(i_q, i_w), res_Trans(i_q, i_w), i_w=1,3), i_q=1,2)
             
    end do
    
    close(20)
    print *, "Generado: datos/todos_los_datos.dat"
    print *, "El archivo tiene 13 columnas: E, luego pares (DOS, Trans) para cada caso."

end program problema5ab_hofstadter_autom