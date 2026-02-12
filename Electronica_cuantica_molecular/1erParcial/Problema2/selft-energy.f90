program main_self_energy
    use isoprec
    use functions
    implicit none

    integer, parameter :: N = 2000
    real(kind=wp) :: E, dE, E_min, E_max
    integer :: k
    
    ! Parámetros físicos
    real(kind=wp) :: ep0 = 0.0_wp
    real(kind=wp) :: V   = 1.0_wp
    
    ! Variables para guardar los distintos cálculos
    real(kind=wp) :: val_gamma_func
    real(kind=wp) :: val_gamma_cmplx
    real(kind=wp) :: val_delta
    
    real(kind=wp) :: val_sigma_pos
    real(kind=wp) :: val_sigma_neg
    real(kind=wp) :: real_part_final
    
    complex(kind=wp) :: val_sigma1
    logical :: inside_band

    ! =========================================================================
    ! CREAR CARPETAS AUTOMÁTICAMENTE
    ! =========================================================================
    ! El argumento wait=.true. espera a que se cree antes de seguir.
    ! El exitstat se usa para que no se cierre el programa si la carpeta ya existe.
    call execute_command_line("mkdir datos", exitstat=k) 
    call execute_command_line("mkdir graficos", exitstat=k)


    open(10, file='datos/datos_sigma.dat')
    
    ! Configuración del rango de energía
    E_min = -3.0_wp
    E_max = 3.0_wp
    dE = (E_max - E_min) / real(N, kind=wp)

    do k = 0, N
        E = E_min + real(k, kind=wp) * dE
        
        ! 1. Verificamos si estamos DENTRO o FUERA de la banda
        ! Condición: |(E-e0)/2| <= V
        if (abs((E - ep0)/2.0_wp) <= V) then
            inside_band = .true.
        else
            inside_band = .false.
        end if
        
        !------------------------------------------------------------
        ! PARTE IMAGINARIA (Comparación de dos métodos)
        !------------------------------------------------------------
        ! Metodo A: Usando la función gamma real
        val_gamma_func = gamma(E, ep0, V)
        
        ! Metodo B: Usando la parte imaginaria de sigma1 compleja
        ! sigma1 = delta - i*gamma => gamma = -aimag(sigma1)

        val_sigma1 = sigma1(E, ep0, V)
        val_gamma_cmplx = -aimag(val_sigma1)
        
        
        !------------------------------------------------------------
        ! PARTE REAL (Construcción por tramos)
        !------------------------------------------------------------
        val_delta = delta(E, ep0) ! Siempre es la recta (E-e0)/2
        
        ! Calculamos las ramas positiva y negativa (solo válidas fuera de banda)
        ! Usamos abs() dentro de las funciones para evitar NaN si estamos dentro
        val_sigma_pos = sigma_pos(E, ep0, V)
        val_sigma_neg = sigma_neg(E, ep0, V)
        
        ! Lógica de selección para graficar la curva continua
        if (inside_band) then
            ! Dentro de la banda, la parte real de Sigma es solo Delta
            real_part_final = val_delta
        else
            ! Fuera de la banda, elegimos la rama que decae a cero
            if (E < ep0) then
                ! A la izquierda (negativos), necesitamos sumar la raíz para cancelar el negativo de Delta
                real_part_final = val_sigma_pos
            else
                ! A la derecha (positivos), necesitamos restar la raíz
                real_part_final = val_sigma_neg
            end if
        end if
        
        !------------------------------------------------------------
        ! GUARDAR DATOS
        !------------------------------------------------------------
        ! Col 1: Energía E
        ! Col 2: Gamma (Función directa) -> LINEA ROJA
        ! Col 3: Gamma (Desde complex)   -> PUNTOS ROJOS (Para verificar)
        ! Col 4: Delta (Recta media)     -> LINEA VERDE
        ! Col 5: Parte Real "Híbrida"    -> LINEA AZUL (Tramos ext + delta int)
        ! Col 6: Sigma Pos (Rama +)      -> Para ver la otra opción
        ! Col 7: Sigma Neg (Rama -)      -> Para ver la otra opción
        
        write(10, *) E, val_gamma_func, val_gamma_cmplx, &
                     val_delta, real_part_final, &
                     val_sigma_pos, val_sigma_neg

    end do

    close(10)
    print *, "Archivo 'datos_sigma.dat' generado exitosamente."

end program main_self_energy