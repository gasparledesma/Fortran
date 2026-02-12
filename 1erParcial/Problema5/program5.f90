program problema5_hofstadter
    use isoprec
    use functions
    implicit none

    ! --- VARIABLES ---
    integer, parameter :: N_energy = 5000
    integer :: k, stat
    
    ! Variables de la Cadena
    integer, parameter :: N_total = 100  
    integer :: n_sitio                   
    
    ! Variables Físicas

    real(kind=wp) :: V = 1.0_wp 
    real(kind=wp) :: W = 0.5_wp          
    real(kind=wp) :: Q                   
    real(kind=wp) :: a = 1.0_wp
    real(kind=wp) :: PI = 3.14159265359_wp

    ! Variables del Bucle de Energia
    real(kind=wp) :: E, dE, E_min, E_max
    real(kind=wp) :: dens_est_total      
    real(kind=wp) :: eta = 0.05_wp     
    
    ! Variables para Funcion de Green
    complex(kind=wp) :: z                ! Energia compleja (E + i*eta)
    complex(kind=wp) :: Sig_L, Sig_R, G_nn
    real(kind=wp)    :: ep_n             ! Energia del sitio n
    real(kind=wp) :: gam_L, gam_R, Transmision_LR

    ! Crear carpetas
    call execute_command_line("mkdir datos", exitstat=stat) 
    call execute_command_line("mkdir graficos", exitstat=stat)
    
    open(20, file='datos/ldos_hofstadter.dat')
    write(20, *) "# Energia   LDOS_Total   Transferencia"
    
    E_min = -4.0_wp
    E_max = 4.0_wp
    dE = (E_max - E_min) / real(N_energy, kind=wp)


    ! Bucle para la energía

    do k = 0, N_energy
        E = E_min + real(k, kind=wp) * dE
        z = cmplx(E, eta, kind=wp)

        dens_est_total = 0.0_wp

        ! Bucle para la suma de los sitios

        do n_sitio = 1, N_total
            
            !Q = 2.0_wp / a
            Q= 2.0_wp*PI/(3.0_wp*a)
            
            ep_n = e_Hofstadter(n_sitio, W, Q)
            Sig_L = sigma_izquierda_Hof(n_sitio, z, W, Q, V)
            Sig_R = sigma_derecha_Hof(n_sitio, N_total, z, W, Q, V)

            G_nn = Green_nn_Hof(z, ep_n, Sig_L, Sig_R)

            dens_est_total = dens_est_total + (-1.0_wp/PI)*aimag(G_nn)

        end do

        write(20, *) E, dens_est_total 
    end do
    
    close(20)
    print *, "Generado: datos/ldos_hofstadter.dat"

end program problema5_hofstadter