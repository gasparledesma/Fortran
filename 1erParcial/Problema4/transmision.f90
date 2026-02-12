program problema4_transmitancia
    use isoprec
    use functions
    implicit none

    ! --- VARIABLES ---
    integer, parameter :: N_energy = 2000
    integer :: k, stat
    
    ! Variables Físicas
    real(kind=wp) :: ep0  = 0.0_wp    
    real(kind=wp) :: V    = 1.0_wp    ! Hopping interno del cable
    real(kind=wp) :: V_l  = 0.3_wp    
    real(kind=wp) :: V_r  = 0.5_wp

    ! Variables del Bucle 
    real(kind=wp) :: E, dE, E_min, E_max
    real(kind=wp) :: gam_L, gam_R, Transmision
    complex(kind=wp) :: Sig_L, Sig_R, G_exacta

    ! Crear carpetas
    call execute_command_line("mkdir datos", exitstat=stat) 
    call execute_command_line("mkdir graficos", exitstat=stat)
    
    open(20, file='datos/transmitancia.dat')
    write(20, *) "# Energia   Transmitancia(T)"
    
    E_min = -3.0_wp
    E_max = 3.0_wp
    dE = (E_max - E_min) / real(N_energy, kind=wp)

    do k = 0, N_energy
        E = E_min + real(k, kind=wp) * dE
        
        Sig_L = (V_l/V)**2 * sigma1(E, ep0, V) 
        Sig_R = (V_r/V)**2 * sigma1(E, ep0, V) 

        gam_L = (V_l/V)**2 * gamma(E, ep0, V)
        gam_R = (V_r/V)**2 * gamma(E, ep0, V)
        

        G_exacta = Green_00(E, ep0, Sig_L, Sig_R)


        Transmision = Transmitancia_00(gam_L, gam_R, G_exacta)

        write(20, *) E, Transmision
    end do
    
    close(20)
    print *, "Generado: datos/transmitancia.dat"

end program problema4_transmitancia