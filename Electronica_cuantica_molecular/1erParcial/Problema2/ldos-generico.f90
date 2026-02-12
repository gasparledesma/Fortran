program problema2c_interactivo
    use isoprec
    use functions
    implicit none

    ! Variables para el bucle de energía
    integer, parameter :: N_puntos = 2000
    integer :: k, j
    real(kind=wp) :: E, dE, E_min, E_max
    
    ! Parámetros Físicos
    real(kind=wp) :: ep0 = 0.0_wp
    real(kind=wp) :: V   = 1.0_wp
    
    ! Variables Complejas
    complex(kind=wp) :: z
    complex(kind=wp), parameter :: im = (0.0_wp, 1.0_wp)
    real(kind=wp), parameter    :: eta = 0.001_wp

    ! Variables para la Recursión
    complex(kind=wp) :: Sigma_right  ! Semi-infinita (fija)
    complex(kind=wp) :: Sigma_left   ! Finita (depende de n)
    complex(kind=wp) :: G_local
    
    ! --- VARIABLES PARA INTERACCIÓN CON USUARIO ---
    integer :: num_sitios_a_graficar
    integer, allocatable :: lista_indices(:)  ! Array dinámico para guardar los índices
    real(kind=wp), allocatable :: valores_ldos(:) ! Array temporal para escribir en archivo

    ! =========================================================================
    ! 1. PREGUNTAR AL USUARIO
    ! =========================================================================
    print *, "--------------------------------------------------------"
    print *, "CALCULO DE LDOS - CADENA SEMI-INFINITA"
    print *, "--------------------------------------------------------"
    print *, "Cuantos sitios quieres graficar en total? (Ej: 3)"
    read *, num_sitios_a_graficar
    
    ! Asignamos memoria para los arrays
    allocate(lista_indices(num_sitios_a_graficar))
    allocate(valores_ldos(num_sitios_a_graficar))
    
    print *, "Ingresa los numeros de los sitios separados por espacio"
    print *, "(Ejemplo: 0 1 2 50 100)"
    read *, lista_indices
    
    print *, "Calculando para sitios: ", lista_indices
    
print *, "Calculando para sitios: ", lista_indices
    
    ! =========================================================================
    ! CREAR CARPETAS AUTOMÁTICAMENTE
    ! =========================================================================
    ! El argumento wait=.true. espera a que se cree antes de seguir.
    ! El exitstat se usa para que no se cierre el programa si la carpeta ya existe.
    call execute_command_line("mkdir datos", exitstat=k) 
    call execute_command_line("mkdir graficos", exitstat=k)

    ! =========================================================================
    ! 2. BUCLE PRINCIPAL
    ! =========================================================================

    open(10, file='datos/ldos_genericos.dat')
   
    ! Escribimos un encabezado manual para recordar qué es cada columna
    write(10, '(A)', advance='no') "# Energy"
    do j = 1, num_sitios_a_graficar
        write(10, '(A,I0,A)', advance='no') "  Site_", lista_indices(j), ""
    end do
    write(10, *) "" ! Salto de línea

    E_min = -3.0_wp
    E_max = 3.0_wp
    dE = (E_max - E_min) / real(N_puntos, kind=wp)

    do k = 0, N_puntos
        E = E_min + real(k, kind=wp) * dE
        z = cmplx(E, eta, kind=wp)
        
        ! A. Calcular Sigma Derecha (Siempre es la semi-infinita)
        ! ------------------------------------------------------
        Sigma_right = (z - ep0)/2.0_wp - sqrt((z-ep0)**2/4.0_wp - V**2)
        ! Corrección de rama si hace falta
        if (aimag(Sigma_right) > 0.0_wp) then
             Sigma_right = (z - ep0)/2.0_wp + sqrt((z-ep0)**2/4.0_wp - V**2)
        end if

        ! B. Calcular LDOS para cada sitio solicitado
        ! ------------------------------------------------------
        do j = 1, num_sitios_a_graficar
            
            ! Llamamos a la función que calcula la cadena finita a la izquierda
            Sigma_left = calcular_sigma_izquierda(lista_indices(j), z, ep0, V)
            
            ! Green Local Total
            G_local = 1.0_wp / (z - ep0 - Sigma_left - Sigma_right)
            
            ! Guardamos en el array temporal
            valores_ldos(j) = -1.0_wp/3.14159265_wp * aimag(G_local)
        end do
        
        ! C. Escribir en archivo: Energía + Lista de valores
        ! Usamos un "Implied Do-Loop" para escribir todas las columnas de una
        write(10, *) E, (valores_ldos(j), j=1, num_sitios_a_graficar)
        
    end do



    close(10)
    print *, "--------------------------------------------------------"
    print *, "Archivo 'ldos_genericos.dat' generado."
    print *, "--------------------------------------------------------"

end program problema2c_interactivo