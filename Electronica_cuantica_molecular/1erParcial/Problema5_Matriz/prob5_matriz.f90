program problema5_matrices
    use isoprec
    use functions
    implicit none

    ! --- Parámetros Generales ---
    integer, parameter :: N_energy = 1000
    integer, parameter :: N_total  = 100
    integer :: k, i_w, i_q
    
    ! Físicos
    real(kind=wp) :: V = 1.0_wp
    real(kind=wp) :: a = 1.0_wp
    
    ! Arrays de Casos a estudiar
    real(kind=wp), dimension(3) :: W_list = (/ 0.5_wp, 2.0_wp, 3.0_wp /)
    real(kind=wp), dimension(2) :: Q_list 
    character(len=20), dimension(2) :: Q_names
    
    ! Variables de bucle
    real(kind=wp) :: W_val, Q_val
    real(kind=wp) :: E, E_min, E_max, dE, eta
    complex(kind=wp) :: z, Sig_L, Sig_R, G1N
    real(kind=wp) :: Gam_L, Gam_R, DOS_Tot, Transmision
    
    ! Archivos
    character(len=64) :: filename

    ! Definición de casos Q
    ! Caso 1: Q = 2/a
    Q_list(1) = 2.0_wp / a
    Q_names(1) = "2_a"
    ! Caso 2: Q = 2*PI/(3a)
    Q_list(2) = 2.0_wp * PI / (3.0_wp * a)
    Q_names(2) = "2pi_3a"

    ! Crear carpeta
    call execute_command_line("mkdir datos", exitstat=k)

    ! --- BUCLES DE CASOS ---
    do i_q = 1, 2
        do i_w = 1, 3
            
            Q_val = Q_list(i_q)
            W_val = W_list(i_w)
            
            ! Generar nombre de archivo automático
            write(filename, '("datos/P5_Q", A, "_W", F3.1, ".dat")') trim(Q_names(i_q)), W_val
            
            open(10, file=filename, status='replace')
            write(10, *) "# Energia   DOS_Total   Transmitancia"
            print *, "Calculando: ", filename

            ! Configuración de Energía
            ! El ancho de banda depende de W, ampliamos el rango para W=3
            E_min = -4.5_wp
            E_max = 4.5_wp
            dE = (E_max - E_min) / real(N_energy, kind=wp)
            eta = 0.05_wp

            ! --- BUCLE DE ENERGÍA ---
            do k = 0, N_energy
                E = E_min + real(k, kind=wp) * dE
                z = cmplx(E, eta, kind=wp)

                ! 1. Self-Energies de los Cables (Cadenas semi-infinitas ordenadas)
                !    Asumimos acople perfecto V_lead = V_chain = 1, Ep=0
                Sig_L = sigma1(E, 0.0_wp, V)
                Sig_R = sigma1(E, 0.0_wp, V)
                
                Gam_L = -aimag(Sig_L)
                Gam_R = -aimag(Sig_R)

                ! 2. Calculo MATRICIAL (DOS y G1N)
                call get_Properties_Matrix(z, W_val, Q_val, V, N_total, &
                                           Sig_L, Sig_R, DOS_Tot, G1N)

                ! 3. Transmisión (Fisher-Lee)
                Transmision = 4.0_wp * Gam_L * Gam_R * (abs(G1N)**2)

                write(10, '(3F16.8)') E, DOS_Tot, Transmision
            end do
            
            close(10)

        end do
    end do

    print *, "--- Calculo Finalizado ---"

end program problema5_matrices