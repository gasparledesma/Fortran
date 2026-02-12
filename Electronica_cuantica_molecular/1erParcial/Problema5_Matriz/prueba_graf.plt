reset

# =============================================================================
# CONFIGURACIÓN GENERAL
# =============================================================================
set grid
set xrange [-4:4]

# Estilos de Línea
# Estilos para Transmisión (Rojo/Azul)
set style line 1 lc rgb "red" lw 2      
set style line 2 lc rgb "blue" lw 2     

# Estilos para DOS (Violeta/Verde Oscuro)
set style line 3 lc rgb "dark-violet" lw 2 
set style line 4 lc rgb "forest-green" lw 2   

# Nota: Ya no definimos "datos =" porque usaremos archivos distintos

# =============================================================================
# PDF 1: TRANSMISIÓN (Columna 3 de cada archivo)
# =============================================================================
set terminal pdfcairo enhanced font 'Sans,10' size 8in,10in
set output "graficos/Resultados_Transmision_Matriz.pdf"

set multiplot layout 3,2 title "Transmisión Electrónica T(E): Método Matricial" font ",14"

# Fijamos Y para Transmisión
set yrange [0:1.1]

# --- FILA 1: W = 0.5 ---
set title "Q = 2/a, W = 0.5"
set ylabel "Transmisión T(E)"
set xlabel "" 
# Usamos columna 1 (Energia) vs 3 (Transmision)
plot "datos/P5_Matriz_Q2_a_W0.5.dat" using 1:3 with lines ls 1 title "T(E)"

set title "Q = 2pi/3a, W = 0.5"
set ylabel ""
plot "datos/P5_Matriz_Q2pi_3a_W0.5.dat" using 1:3 with lines ls 2 title "T(E)"

# --- FILA 2: W = 2.0 ---
set title "Q = 2/a, W = 2.0"
set ylabel "Transmisión T(E)"
plot "datos/P5_Matriz_Q2_a_W2.0.dat" using 1:3 with lines ls 1 title "T(E)"

set title "Q = 2pi/3a, W = 2.0"
set ylabel ""
plot "datos/P5_Matriz_Q2pi_3a_W2.0.dat" using 1:3 with lines ls 2 title "T(E)"

# --- FILA 3: W = 3.0 ---
set title "Q = 2/a, W = 3.0"
set ylabel "Transmisión T(E)"
set xlabel "Energía (E)"
plot "datos/P5_Matriz_Q2_a_W3.0.dat" using 1:3 with lines ls 1 title "T(E)"

set title "Q = 2pi/3a, W = 3.0"
set ylabel ""
set xlabel "Energía (E)"
plot "datos/P5_Matriz_Q2pi_3a_W3.0.dat" using 1:3 with lines ls 2 title "T(E)"

unset multiplot
unset output  # Cerramos el primer PDF

# =============================================================================
# PDF 2: DENSIDAD DE ESTADOS (Columna 2 de cada archivo)
# =============================================================================
set terminal pdfcairo enhanced font 'Sans,10' size 8in,10in
set output "graficos/Resultados_DOS_Matriz.pdf"

set multiplot layout 3,2 title "Densidad de Estados (DOS): Método Matricial" font ",14"

# IMPORTANTE: Liberamos el eje Y porque la DOS puede ser muy alta
set autoscale y 
set yrange [*:*] 

# --- FILA 1: W = 0.5 ---
set title "Q = 2/a, W = 0.5"
set ylabel "DOS (u.a.)"
set xlabel ""
# Usamos columna 1 (Energia) vs 2 (DOS)
plot "datos/P5_Matriz_Q2_a_W0.5.dat" using 1:2 with lines ls 3 title "DOS"

set title "Q = 2pi/3a, W = 0.5"
set ylabel ""
plot "datos/P5_Matriz_Q2pi_3a_W0.5.dat" using 1:2 with lines ls 4 title "DOS"

# --- FILA 2: W = 2.0 ---
set title "Q = 2/a, W = 2.0"
set ylabel "DOS (u.a.)"
plot "datos/P5_Matriz_Q2_a_W2.0.dat" using 1:2 with lines ls 3 title "DOS"

set title "Q = 2pi/3a, W = 2.0"
set ylabel ""
plot "datos/P5_Matriz_Q2pi_3a_W2.0.dat" using 1:2 with lines ls 4 title "DOS"

# --- FILA 3: W = 3.0 ---
set title "Q = 2/a, W = 3.0"
set ylabel "DOS (u.a.)"
set xlabel "Energía (E)"
plot "datos/P5_Matriz_Q2_a_W3.0.dat" using 1:2 with lines ls 3 title "DOS"

set title "Q = 2pi/3a, W = 3.0"
set ylabel ""
set xlabel "Energía (E)"
plot "datos/P5_Matriz_Q2pi_3a_W3.0.dat" using 1:2 with lines ls 4 title "DOS"

unset multiplot
unset output # Cerramos el segundo PDF

# =============================================================================
# PANTALLA (Check Rápido)
# =============================================================================
set term wxt persist size 900,600 font "Sans,10"
set multiplot layout 1,2 title "Vista Rápida en Pantalla (Caso W=2.0)"

set autoscale y
set title "DOS (Q=2/a, W=2.0)"
plot "datos/P5_Matriz_Q2_a_W2.0.dat" using 1:2 with lines ls 3 title "DOS"

set yrange [0:1.1]
set title "Transmisión (Q=2/a, W=2.0)"
plot "datos/P5_Matriz_Q2_a_W2.0.dat" using 1:3 with lines ls 1 title "Trans"

unset multiplot