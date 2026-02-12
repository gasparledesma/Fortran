reset
set encoding utf8
set grid

# =============================================================================
# DEFINICIÓN DE ESTILOS Y COLORES
# =============================================================================
set style line 1 lc rgb "blue" lw 2      # Estilo para Inciso A (Línea sólida azul)
set style line 2 lc rgb "red" lw 2 dt 2  # Estilo para Inciso B (Línea punteada roja)

# =============================================================================
# GRÁFICO 1: PROBABILIDAD DE SUPERVIVENCIA
# =============================================================================
# Configuración del gráfico
set title "Decaimiento de Probabilidad P(t)"
set xlabel "Tiempo (t)"
set ylabel "Probabilidad"
set xrange [0:5]
set yrange [0:1]
set key top right

# 1.A) Generar el archivo PDF
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/Probabilidad.pdf"
plot "datos/comparacion_probabilidad.dat" u 1:2 w l ls 1 title "Inciso A (1 Cable)", \
     "datos/comparacion_probabilidad.dat" u 1:3 w l ls 2 title "Inciso B (2 Cables)"
unset output  # Cierra el PDF para que se guarde bien

# 1.B) Mostrar en Pantalla (Ventana 0)
# 'wxt 0' abre la ventana número 0. 'persist' la deja abierta.
set term wxt 0 persist size 800,600 font 'Sans,10' title "Gráfico 1: Probabilidad"
replot


# =============================================================================
# GRÁFICO 2: DENSIDAD DE ESTADOS (LDOS)
# =============================================================================
# Configuración del gráfico
set title "Comparación de LDOS (Ancho de Banda)"
set xlabel "Energía (E)"
set ylabel "Densidad de Estados"
set xrange [-5:5]
set autoscale y 
set key top right

# 2.A) Generar el archivo PDF
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/LDOS.pdf"
plot "datos/comparacion_ldos.dat" u 1:2 w l ls 1 title "Inciso A (Angosta)", \
     "datos/comparacion_ldos.dat" u 1:3 w l ls 2 title "Inciso B (Ancha)"
unset output

# 2.B) Mostrar en Pantalla (Ventana 1)
# 'wxt 1' abre una SEGUNDA ventana distinta.
set term wxt 1 persist size 800,600 font 'Sans,10' title "Gráfico 2: LDOS"
replot

# Mensaje final en la terminal
print ">> Se generaron 'graficos/Probabilidad.pdf' y 'graficos/LDOS.pdf'"
print ">> Las ventanas quedaron abiertas."