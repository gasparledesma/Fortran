set terminal pdfcairo enhanced font 'Sans,10' size 11in,8.5in
set output "graficos/Resultados_P5_Separados.pdf"

# Definimos estilos
set style line 1 lc rgb "dark-violet" lw 2   # DOS
set style line 2 lc rgb "forest-green" lw 1.5 # Transmisión

# Configuración general
set grid
set xrange [-4.5:4.5]

# =============================================================================
# PÁGINA 1: Caso Q = 2/a
# =============================================================================
set multiplot layout 2,3 title "Caso Q = 2/a: Comparación DOS vs Transmisión" font ",14"

# --- FILA 1: DENSIDAD DE ESTADOS (DOS) ---
set ylabel "DOS Total" textcolor rgb "dark-violet"
set xlabel ""
set format x ""  # Ocultamos numeros del eje X en la fila de arriba

# W = 0.5
set title "W = 0.5V"
plot "datos/P5_Q2_a_W0.5.dat" u 1:2 w l ls 1 notitle

# W = 2.0
set title "W = 2.0V"
plot "datos/P5_Q2_a_W2.0.dat" u 1:2 w l ls 1 notitle

# W = 3.0
set title "W = 3.0V"
plot "datos/P5_Q2_a_W3.0.dat" u 1:2 w l ls 1 notitle

# --- FILA 2: TRANSMISIÓN (Escala Independiente) ---
set ylabel "Transmisión T(E)" textcolor rgb "forest-green"
set xlabel "Energía (E)"
set format x "%g"  # Volvemos a mostrar numeros en el eje X
set autoscale y    # <--- ESTO ES LA CLAVE: Escala automatica para ver picos chicos

# W = 0.5
set title "Transmisión (W=0.5)"
plot "datos/P5_Q2_a_W0.5.dat" u 1:3 w l ls 2 notitle

# W = 2.0
set title "Transmisión (W=2.0)"
plot "datos/P5_Q2_a_W2.0.dat" u 1:3 w l ls 2 notitle

# W = 3.0
set title "Transmisión (W=3.0)"
plot "datos/P5_Q2_a_W3.0.dat" u 1:3 w l ls 2 notitle

unset multiplot

# =============================================================================
# PÁGINA 2: Caso Q = 2pi/3a
# =============================================================================
set multiplot layout 2,3 title "Caso Q = 2pi/3a: Comparación DOS vs Transmisión" font ",14"

# --- FILA 1: DOS ---
set ylabel "DOS Total" textcolor rgb "dark-violet"
set xlabel ""
set format x ""

set title "W = 0.5V"
plot "datos/P5_Q2pi_3a_W0.5.dat" u 1:2 w l ls 1 notitle

set title "W = 2.0V"
plot "datos/P5_Q2pi_3a_W2.0.dat" u 1:2 w l ls 1 notitle

set title "W = 3.0V"
plot "datos/P5_Q2pi_3a_W3.0.dat" u 1:2 w l ls 1 notitle

# --- FILA 2: TRANSMISIÓN ---
set ylabel "Transmisión T(E)" textcolor rgb "forest-green"
set xlabel "Energía (E)"
set format x "%g"
set autoscale y  # <--- Escala automatica

set title "Transmisión (W=0.5)"
plot "datos/P5_Q2pi_3a_W0.5.dat" u 1:3 w l ls 2 notitle

set title "Transmisión (W=2.0)"
plot "datos/P5_Q2pi_3a_W2.0.dat" u 1:3 w l ls 2 notitle

set title "Transmisión (W=3.0)"
plot "datos/P5_Q2pi_3a_W3.0.dat" u 1:3 w l ls 2 notitle

unset multiplot
unset output