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

# Archivo de datos
datos = "datos/todos_los_datos.dat"

# =============================================================================
# PDF 1: TRANSMISIÓN (Rango fijo 0 a 1.1)
# =============================================================================
set terminal pdfcairo enhanced font 'Sans,10' size 8in,10in
set output "graficos/Resultados_Transmision.pdf"

set multiplot layout 3,2 title "Transmisión Electrónica T(E): Modelo de Hofstadter" font ",14"

# Fijamos Y para Transmisión
set yrange [0:1.1]

# --- FILA 1: W = 0.5 ---
set title "Q = 2/a, W = 0.5"
set ylabel "Transmisión T(E)"
set xlabel "" 
plot datos using 1:3 with lines ls 1 title "T(E)"

set title "Q = 2pi/3a, W = 0.5"
set ylabel ""
plot datos using 1:9 with lines ls 2 title "T(E)"

# --- FILA 2: W = 2.0 ---
set title "Q = 2/a, W = 2.0"
set ylabel "Transmisión T(E)"
plot datos using 1:5 with lines ls 1 title "T(E)"

set title "Q = 2pi/3a, W = 2.0"
set ylabel ""
plot datos using 1:11 with lines ls 2 title "T(E)"

# --- FILA 3: W = 3.0 ---
set title "Q = 2/a, W = 3.0"
set ylabel "Transmisión T(E)"
set xlabel "Energía (E)"
plot datos using 1:7 with lines ls 1 title "T(E)"

set title "Q = 2pi/3a, W = 3.0"
set ylabel ""
set xlabel "Energía (E)"
plot datos using 1:13 with lines ls 2 title "T(E)"

unset multiplot
unset output  # Cerramos el primer PDF

# =============================================================================
# PDF 2: DENSIDAD DE ESTADOS (DOS) - Escala Automática
# =============================================================================
set terminal pdfcairo enhanced font 'Sans,10' size 8in,10in
set output "graficos/Resultados_DOS.pdf"

set multiplot layout 3,2 title "Densidad de Estados (DOS): Modelo de Hofstadter" font ",14"

# IMPORTANTE: Liberamos el eje Y porque la DOS puede ser muy alta
set autoscale y 
set yrange [*:*] 

# --- FILA 1: W = 0.5 ---
set title "Q = 2/a, W = 0.5"
set ylabel "DOS (u.a.)"
set xlabel ""
plot datos using 1:2 with lines ls 3 title "DOS"

set title "Q = 2pi/3a, W = 0.5"
set ylabel ""
plot datos using 1:8 with lines ls 4 title "DOS"

# --- FILA 2: W = 2.0 ---
set title "Q = 2/a, W = 2.0"
set ylabel "DOS (u.a.)"
plot datos using 1:4 with lines ls 3 title "DOS"

set title "Q = 2pi/3a, W = 2.0"
set ylabel ""
plot datos using 1:10 with lines ls 4 title "DOS"

# --- FILA 3: W = 3.0 ---
set title "Q = 2/a, W = 3.0"
set ylabel "DOS (u.a.)"
set xlabel "Energía (E)"
plot datos using 1:6 with lines ls 3 title "DOS"

set title "Q = 2pi/3a, W = 3.0"
set ylabel ""
set xlabel "Energía (E)"
plot datos using 1:12 with lines ls 4 title "DOS"

unset multiplot
unset output # Cerramos el segundo PDF

# =============================================================================
# PANTALLA (Check Rápido)
# =============================================================================
set term wxt persist size 900,600 font "Sans,10"
set multiplot layout 1,2 title "Vista Rápida en Pantalla (Caso W=2.0)"

set autoscale y
set title "DOS (Q=2/a, W=2.0)"
plot datos using 1:4 with lines ls 3 title "DOS"

set yrange [0:1.1]
set title "Transmisión (Q=2/a, W=2.0)"
plot datos using 1:5 with lines ls 1 title "Trans"

unset multiplot