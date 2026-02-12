program problema5_matrices
    use isoprec
    use functions
    implicit none

    ! --- 1. DECLARACIONES (Todo lo que define variables va aqui arriba) ---
    integer, parameter :: N_energy = 4000 
    integer, parameter :: N_total  = 100
    integer :: k, i_w, i_q, stat 
    
    ! Físicos
    real(kind=wp) :: V = 1.0_wp
    real(kind=wp) :: a = 1.0_wp

    ! Cables (MOVIDO AQUI ARRIBA)
    real(kind=wp) :: V_L = 0.5_wp
    real(kind=wp) :: V_R = 0.5_wp
    
    ! Arrays de Casos
    real(kind=wp), dimension(3) :: W_list = (/ 0.5_wp, 2.0_wp, 3.0_wp /)
    real(kind=wp), dimension(2) :: Q_list 
    character(len=20), dimension(2) :: Q_names
    
    ! Variables de bucle
    real(kind=wp) :: W_val, Q_val
    real(kind=wp) :: E, E_min, E_max, dE, eta
    complex(kind=wp) :: z, Sig_L, Sig_R, G1N
    real(kind=wp) :: Gam_L, Gam_R, DOS_Tot, Transmision
    
    character(len=64) :: filename

    ! --- 2. INSTRUCCIONES EJECUTABLES (Empiezan aqui) ---

    ! Definición de casos Q
    Q_list(1) = 2.0_wp / a
    Q_names(1) = "2_a"
    Q_list(2) = 2.0_wp * PI / (3.0_wp * a)
    Q_names(2) = "2pi_3a"

    ! Crear carpeta 
    call execute_command_line("mkdir datos", exitstat=stat)

    ! --- BUCLES DE CASOS ---
    do i_q = 1, 2
        do i_w = 1, 3
            
            Q_val = Q_list(i_q)
            W_val = W_list(i_w)
            
            ! Nombre de archivo individual
            write(filename, '("datos/P5_Matriz_Q", A, "_W", F3.1, ".dat")') trim(Q_names(i_q)), W_val
            
            open(10, file=filename, status='replace')

            ! dentro del bucle de parámetros...
            write(10, *) "# Energia   DOS_Total   Transmitancia"
            print *, "Calculando (Alta Resolucion): ", filename

            E_min = -4.5_wp
            E_max = 4.5_wp
            dE = (E_max - E_min) / real(N_energy, kind=wp)
            
            ! 2. REDUCIR ETA DRASTICAMENTE
            eta = 0.0001_wp   ! <--- ESTE ES EL CAMBIO CLAVE PARA N=100

            ! --- BUCLE DE ENERGÍA ---
            do k = 0, N_energy
                E = E_min + real(k, kind=wp) * dE
                z = cmplx(E, eta, kind=wp)

                ! 1. Self-Energies con Acople (Ahora V_L y V_R ya existen)
                Sig_L = (V_L/V)**2 * sigma1(E, 0.0_wp, V)
                Sig_R = (V_R/V)**2 * sigma1(E, 0.0_wp, V)
                
                Gam_L = -aimag(Sig_L)
                Gam_R = -aimag(Sig_R)

                ! 2. Calculo MATRICIAL (DOS y G1N)
                call get_Properties_Matrix(z, W_val, Q_val, V, N_total, &
                                           Sig_L, Sig_R, DOS_Tot, G1N)

                ! 3. Transmisión
                Transmision = 4.0_wp * Gam_L * Gam_R * (abs(G1N)**2)

                ! 4. Escritura
                write(10, '(3ES20.10)') E, DOS_Tot, Transmision
            end do
            
            close(10)

        end do
    end do

    print *, "--- Calculo Finalizado ---"

end program problema5_matrices