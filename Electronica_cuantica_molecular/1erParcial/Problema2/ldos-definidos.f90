program problema2c_ldos
    use isoprec
    use functions  
    implicit none

    integer, parameter :: N_puntos = 2000
    integer :: k, n_site, i_loop
    real(kind=wp) :: E, dE, E_min, E_max
    
    ! Parámetros
    real(kind=wp) :: ep0 = 0.0_wp
    real(kind=wp) :: V   = 1.0_wp
    
    ! Variables Complejas
    complex(kind=wp) :: z
    complex(kind=wp) :: Sigma_semi_right  ! Lo que ve a la derecha (siempre igual)
    complex(kind=wp) :: Sigma_finite_left ! Lo que ve a la izquierda (cambia con n)
    complex(kind=wp) :: G_local
    
    ! Arrays para guardar LDOS de distintos sitios
    real(kind=wp) :: ldos_0, ldos_1, ldos_2, ldos_infinite
    
    ! Definimos i
    complex(kind=wp), parameter :: im = (0.0_wp, 1.0_wp)
    real(kind=wp), parameter    :: eta = 0.001_wp

    call execute_command_line("mkdir datos", exitstat=k) 
    call execute_command_line("mkdir graficos", exitstat=k)

    
    open(10, file='datos/ldos_definidos.dat')
    E_min = -3.0_wp
    E_max = 3.0_wp
    dE = (E_max - E_min) / real(N_puntos, kind=wp)

    do k = 0, N_puntos
        E = E_min + real(k, kind=wp) * dE
        z = cmplx(E, eta, kind=wp)
        
        ! 1. Calcular Sigma Semi-Infinita (La misma para todos a la derecha)
        ! Usamos la fórmula: Sigma = (z-e0)/2 - sqrt(...) 
        ! Ojo: En tu modulo funciones definiste 'sigma_neg' o similar. 
        ! Aqui lo escribo directo en complejo para no errar:
        
        Sigma_semi_right = (z - ep0)/2.0_wp - sqrt((z-ep0)**2/4.0_wp - V**2)
        ! Nota: Fortran elige la raiz correcta para complejos usualmente, 
        ! pero si sale invertida (parte imag positiva), la corregimos:
        if (aimag(Sigma_semi_right) > 0.0_wp) then
             Sigma_semi_right = (z - ep0)/2.0_wp + sqrt((z-ep0)**2/4.0_wp - V**2)
        end if


        ! --- SITIO 0 (Superficie) ---
        ! Izquierda: Nada (0). Derecha: Semi-infinita.
        G_local = 1.0_wp / (z - ep0 - Sigma_semi_right)
        ldos_0  = -1.0_wp/3.14159_wp * aimag(G_local)


        ! --- SITIO 1 ---
        ! Izquierda: Sitio 0 aislado. Derecha: Semi-infinita.
        ! Sigma_izq = V^2 / (z - ep0)
        Sigma_finite_left = V**2 / (z - ep0)
        G_local = 1.0_wp / (z - ep0 - Sigma_finite_left - Sigma_semi_right)
        ldos_1  = -1.0_wp/3.14159_wp * aimag(G_local)


        ! --- SITIO 2 ---
        ! Izquierda: Sitio 1 conectado a 0.
        ! Sigma_izq = V^2 / (z - ep0 - V^2/(z-ep0))
        Sigma_finite_left = V**2 / (z - ep0 - V**2/(z - ep0))
        G_local = 1.0_wp / (z - ep0 - Sigma_finite_left - Sigma_semi_right)
        ldos_2  = -1.0_wp/3.14159_wp * aimag(G_local)


        ! --- INFINITA (Para comparar) ---
        ! Izquierda: Semi-Infinita. Derecha: Semi-Infinita.
        G_local = 1.0_wp / (z - ep0 - 2.0_wp*Sigma_semi_right)
        ldos_infinite = -1.0_wp/3.14159_wp * aimag(G_local)

        write(10, *) E, ldos_0, ldos_1, ldos_2, ldos_infinite
    end do

    close(10)
    print *, "Datos generados en ldos_definidos.dat"

end program problema2c_ldos