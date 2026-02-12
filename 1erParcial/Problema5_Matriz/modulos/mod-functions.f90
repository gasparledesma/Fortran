module functions
    use isoprec
    implicit none

    real(kind=wp), parameter :: PI = 3.14159265359_wp

    contains

    ! ------------------------------------------------------------------------
    ! Funciones Básicas (Cables / Leads)
    ! ------------------------------------------------------------------------
    function delta(t, epsilon_0)
        real(kind=wp), intent(in) :: t, epsilon_0
        real(kind=wp)             :: delta
        delta = (t - epsilon_0) / 2.0_wp
    end function delta

    function gamma(t, epsilon_0, V_x)
        real(kind=wp), intent(in) :: t, epsilon_0, V_x
        real(kind=wp)             :: gamma, arg
        arg = V_x**2 - ((t - epsilon_0)/2.0_wp)**2
        if (arg > 0.0_wp) then
            gamma = sqrt(arg)
        else
            gamma = 0.0_wp
        end if
    end function gamma

    function sigma1(t, epsilon_0, V_x) result(res)
        real(kind=wp), intent(in) :: t, epsilon_0, V_x
        complex(kind=wp)          :: res
        complex(kind=wp), parameter :: i = (0.0_wp, 1.0_wp)
        res = delta(t, epsilon_0) - i * gamma(t, epsilon_0, V_x)
    end function sigma1

    ! ------------------------------------------------------------------------
    ! Energía de Hofstadter
    ! ------------------------------------------------------------------------
    function e_Hofstadter(n, W, Q_val) result(en)
        integer, intent(in) :: n
        real(kind=wp), intent(in) :: W, Q_val
        real(kind=wp) :: en
        ! eps_n = W * cos(Q * n * a), asumiendo a=1 en Q
        en = W * cos(Q_val * real(n, kind=wp))
    end function e_Hofstadter

    ! ------------------------------------------------------------------------
    ! RUTINA PRINCIPAL MATRICIAL
    ! Calcula DOS Total y G1N resolviendo el sistema lineal
    ! ------------------------------------------------------------------------
    subroutine get_Properties_Matrix(z, W, Q, V, N_total, Sig_L, Sig_R, dos_total, g1n_val)
        complex(kind=wp), intent(in)  :: z, Sig_L, Sig_R
        real(kind=wp), intent(in)     :: W, Q, V
        integer, intent(in)           :: N_total
        real(kind=wp), intent(out)    :: dos_total
        complex(kind=wp), intent(out) :: g1n_val
        
        ! Arrays para Thomas (se asignan y liberan en cada llamada o pueden ser automaticos)
        complex(kind=wp), allocatable :: d(:), u(:), l(:), rhs(:), x(:)
        complex(kind=wp) :: m
        integer :: i, j

        allocate(d(N_total), u(N_total), l(N_total), rhs(N_total), x(N_total))

        dos_total = 0.0_wp
        g1n_val   = (0.0_wp, 0.0_wp)

        ! --- BUCLE SOBRE CADA SITIO 'j' ---
        ! Para obtener la traza (DOS total), necesitamos G_jj para j=1..N
        ! Resolvemos A * x = e_j, entonces x es la columna j de G.
        ! El elemento x(j) es G_jj.
        
        do j = 1, N_total
            
            ! 1. Construir la Matriz Tridiagonal (Reinicializar en cada paso)
            do i = 1, N_total
                d(i) = z - e_Hofstadter(i, W, Q)
                if (i < N_total) u(i) = -V
                if (i > 1)       l(i) = -V
                rhs(i) = (0.0_wp, 0.0_wp)
            end do
            
            ! Agregar Self-Energies en los bordes
            d(1)       = d(1)       - Sig_L
            d(N_total) = d(N_total) - Sig_R

            ! Fuente en el sitio j (Delta de Kronecker)
            rhs(j) = (1.0_wp, 0.0_wp)

            ! 2. Resolver por Thomas (TDMA)
            ! Forward
            do i = 2, N_total
                m = l(i) / d(i-1)
                d(i) = d(i) - m * u(i-1)
                rhs(i) = rhs(i) - m * rhs(i-1)
            end do
            ! Backward
            x(N_total) = rhs(N_total) / d(N_total)
            do i = N_total-1, 1, -1
                x(i) = (rhs(i) - u(i) * x(i+1)) / d(i)
            end do

            ! 3. Acumular DOS (Parte imaginaria de G_jj)
            ! x(j) es el elemento diagonal G_jj
            dos_total = dos_total + (-1.0_wp/PI) * aimag(x(j))

            ! 4. Extraer G_1N para Transmitancia
            ! Si la fuente estaba en j=N (ultima iteracion), x es la columna N.
            ! El elemento x(1) corresponde a G_{1,N}.
            if (j == N_total) then
                g1n_val = x(1)
            end if

        end do

        deallocate(d, u, l, rhs, x)

    end subroutine get_Properties_Matrix

end module functions