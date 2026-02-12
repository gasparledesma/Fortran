program problema5ab_hofstadter
    use isoprec
    use functions
    implicit none

    ! --- 1. DECLARACIONES ---
    integer, parameter :: N_energy = 1000
    integer, parameter :: N_total = 100 
    integer :: k, stat, n_sitio
    
    ! Parametros Fisicos
    real(kind=wp) :: V = 1.0_wp 
    real(kind=wp) :: W = 0.5_wp          
    real(kind=wp) :: Q                   
    real(kind=wp) :: a = 1.0_wp
    real(kind=wp) :: PI = 3.14159265359_wp
    
    ! Parametros de los Cables (Ordenados)
    real(kind=wp) :: ep_lead = 0.0_wp    
    real(kind=wp) :: V_L = 0.5_wp        
    real(kind=wp) :: V_R = 0.5_wp        

    ! Variables de Energia
    real(kind=wp) :: E, dE, E_min, E_max, eta = 0.005_wp
    complex(kind=wp) :: z

    ! Variables de Resultado
    real(kind=wp) :: dens_est_total      
    real(kind=wp) :: Transmision_T

    ! Variables Auxiliares Green / Sigma
    complex(kind=wp) :: Sig_L, Sig_R, G_nn
    complex(kind=wp) :: Sig_Cable_L, Sig_Cable_R, Sig_Cadena_Acumulada
    real(kind=wp)    :: ep_n
    real(kind=wp)    :: Gam_L_eff, Gam_R_phys


    call execute_command_line("mkdir datos", exitstat=stat) 
    
    open(20, file='datos/ldos_transf_hofstadter.dat')
    write(20, *) "# Energia   LDOS_Total   Transmision"
    
  
    Q = 2.0_wp / a 
     !Q = 2.0_wp * PI / (3.0_wp * a)

    E_min = -4.0_wp
    E_max = 4.0_wp
    dE = (E_max - E_min) / real(N_energy, kind=wp)

    ! === BUCLE DE ENERGÍA ===
    do k = 0, N_energy
        E = E_min + real(k, kind=wp) * dE
        z = cmplx(E, eta, kind=wp)

        ! -----------------------------------------------------
        !DENSIDAD DE ESTADOS
        ! -----------------------------------------------------
        dens_est_total = 0.0_wp
        
        do n_sitio = 1, N_total
            ep_n  = e_Hofstadter(n_sitio, W, Q)
            
            Sig_L = sigma_izquierda_Hof(n_sitio, z, W, Q, V)
            Sig_R = sigma_derecha_Hof(n_sitio, N_total, z, W, Q, V)
            
            G_nn  = Green_nn_Hof(z, ep_n, Sig_L, Sig_R)
            dens_est_total = dens_est_total + (-1.0_wp/PI)*aimag(G_nn)
        end do

        ! -----------------------------------------------------
        ! Inciso B: TRANSMISIÓN (Global)
        ! -----------------------------------------------------

        Sig_Cable_L = (V_L/V)**2 * sigma1(E, ep_lead, V)
        Sig_Cable_R = (V_R/V)**2 * sigma1(E, ep_lead, V)

        Sig_Cadena_Acumulada = sigma_izquierda_con_init(N_total, z, W, Q, V, Sig_Cable_L)

        ! 3. Green en el ultimo sitio (N)
        !    El sitio N siente: 
        !       a) Todo lo que viene de la izquierda (Cadena + Cable L) -> Sig_Cadena_Acumulada
        !       b) El cable derecho directo -> Sig_Cable_R
        ep_n = e_Hofstadter(N_total, W, Q) ! Energia del sitio N
        
        G_nn = 1.0_wp / (z - ep_n - Sig_Cadena_Acumulada - Sig_Cable_R)

        ! 4. Calculamos Gammas Efectivos
        !    Gamma_L_Efectivo es la parte imaginaria de todo lo acumulado
        Gam_L_eff  = -aimag(Sig_Cadena_Acumulada)
        !    Gamma_R_Fisico es la parte imaginaria del cable derecho
        Gam_R_phys = -aimag(Sig_Cable_R)

        ! 5. Formula de Fisher-Lee Exacta para 1D
        Transmision_T = 4.0_wp * Gam_L_eff * Gam_R_phys * (abs(G_nn)**2)

        write(20, *) E, dens_est_total, Transmision_T
    end do
    
    close(20)
    print *, "Generado: datos/ldos_transf_hofstadter.dat"

end program problema5ab_hofstadter