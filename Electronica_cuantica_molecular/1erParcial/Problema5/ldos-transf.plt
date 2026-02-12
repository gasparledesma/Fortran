reset

# =============================================================================
# GRAFICO 1: LDOS (Ventana 0)
# =============================================================================
# 'wxt 0' fuerza a usar la ventana numero 0
set term wxt 0 persist size 700,600 font "Sans,10" title "Grafico LDOS"

set xlabel "Energía (E)"
set ylabel "Densidad de Estados N(E)"
set grid
set key top right box

set xrange [-4:4]

# Graficamos en pantalla (Columna 2)
plot "datos/ldos_transf_hofstadter.dat" using 1:2 with lines lw 2 lc rgb "blue" title "LDOS (Q=2/3a, W=0.5V)"

# --- Exportar a PDF ---
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/ldos_hofstadter-Q_15-W_05.pdf"
replot
unset output


# =============================================================================
# GRAFICO 2: TRANSFERENCIA (Ventana 1)
# =============================================================================
# Reseteamos para limpiar configuraciones previas
reset 

# 'wxt 1' abre una SEGUNDA ventana distinta
set term wxt 1 persist size 700,600 font "Sans,10" title "Grafico Transmision"

set xlabel "Energía (E)"
set ylabel "Transmitancia T(E)"
set grid
set key top right box
set xrange [-4:4]
set yrange [0:1.1]  # La transmision no pasa de 1, esto ayuda a ver mejor

# Graficamos en pantalla (Columna 3)
plot "datos/ldos_transf_hofstadter.dat" using 1:3 with lines lw 2 lc rgb "red" title "Transmisión (Q=2/3a, W=0.5V)"

# --- Exportar a PDF ---
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/transf_hofstadter-Q_15-W_05.pdf"
replot
unset output