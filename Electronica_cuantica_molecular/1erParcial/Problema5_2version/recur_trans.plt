reset

# =============================================================================
# CONFIGURACIÓN GENERAL
# =============================================================================
set grid
set xrange [-4.5:4.5]   # Coincide con tu E_min y E_max del Fortran
set yrange [0:1.1]      # La transmisión va de 0 a 1

# Definimos estilos de linea para diferenciar los Q
set style line 1 lc rgb "red" lw 2      # Para Q = 2/a
set style line 2 lc rgb "blue" lw 2     # Para Q = 2pi/3a

# Nombre del archivo generado por tu código
archivo = "datos/Trans_Recursiva_Todos.dat"

# =============================================================================
# GENERACIÓN DEL PDF (LAYOUT 3x2)
# =============================================================================
set terminal pdfcairo enhanced font 'Sans,10' size 8in,10in
set output "graficos/Resultados_Recursivo_Solo.pdf"

set multiplot layout 3,2 title "Transmisión (Método Recursivo): N=100, eta=0.0001" font ",14"

# -----------------------------------------------------------------------------
# FILA 1: W = 0.5
# -----------------------------------------------------------------------------
# -- Izquierda: Q = 2/a (Columna 3) --
set title "Q = 2/a, W = 0.5"
set ylabel "Transmisión T(E)"
set xlabel "" 
plot archivo using 1:3 with lines ls 1 title "T(E)"

# -- Derecha: Q = 2pi/3a (Columna 9) --
set title "Q = 2pi/3a, W = 0.5"
set ylabel ""
plot archivo using 1:9 with lines ls 2 title "T(E)"

# -----------------------------------------------------------------------------
# FILA 2: W = 2.0
# -----------------------------------------------------------------------------
# -- Izquierda: Q = 2/a (Columna 5) --
set title "Q = 2/a, W = 2.0"
set ylabel "Transmisión T(E)"
plot archivo using 1:5 with lines ls 1 title "T(E)"

# -- Derecha: Q = 2pi/3a (Columna 11) --
set title "Q = 2pi/3a, W = 2.0"
set ylabel ""
plot archivo using 1:11 with lines ls 2 title "T(E)"

# -----------------------------------------------------------------------------
# FILA 3: W = 3.0
# -----------------------------------------------------------------------------
# -- Izquierda: Q = 2/a (Columna 7) --
set title "Q = 2/a, W = 3.0"
set ylabel "Transmisión T(E)"
set xlabel "Energía (E)"
plot archivo using 1:7 with lines ls 1 title "T(E)"

# -- Derecha: Q = 2pi/3a (Columna 13) --
set title "Q = 2pi/3a, W = 3.0"
set ylabel ""
set xlabel "Energía (E)"
plot archivo using 1:13 with lines ls 2 title "T(E)"

unset multiplot
unset output

# =============================================================================
# VISTA RÁPIDA EN PANTALLA (Opcional, solo para chequear que anduvo)
# =============================================================================
set term wxt persist size 800,600 font "Sans,10"
set title "Vista Rápida: Caso Q=2/a, W=2.0"
plot archivo using 1:5 with lines ls 1 title "Check W=2.0"