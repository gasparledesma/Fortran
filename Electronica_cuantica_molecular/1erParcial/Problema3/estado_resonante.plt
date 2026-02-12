reset
set encoding utf8
set grid

# =============================================================================
# 1. GENERACIÓN DEL PDF
# =============================================================================
set term pdfcairo enhanced font 'Sans,12' size 10in,5in
set output "graficos/Comparacion_Inciso_AB.pdf"

# Estilos
set style line 1 lc rgb "blue" lw 2 
set style line 2 lc rgb "red" lw 2 dt 2
set style fill transparent solid 0.3 noborder

#set multiplot layout 1,2 title "Comparación: 1 Lead (Azul) vs 2 Leads (Rojo)" font ",14"

    # --- GRAFICO 1: PROBABILIDAD (Tiempo) ---
    set title "Decaimiento de Probabilidad P(t)"
    set xlabel "Tiempo (t)"
    set ylabel "Probabilidad"
    set key top right
    
    # CAMBIO AQUI: Rango de 0 a 5
    set xrange [0:5]
    
    plot "datos/comparacion_probabilidad.dat" u 1:2 w l ls 1 title "Inciso A (1 Cable)", \
         "datos/comparacion_probabilidad.dat" u 1:3 w l ls 2 title "Inciso B (2 Cables)"

    # --- GRAFICO 2: LDOS (Energía) ---
    set title "Ensanchamiento de la LDOS"
    set xlabel "Energía (E)"
    set ylabel "Densidad de Estados"
    
    # CAMBIO AQUI: Rango de -5 a 5
    set xrange [-5:5]
    
    plot "datos/comparacion_ldos.dat" u 1:2 with lines lc rgb "blue" title "Inciso A (Angosta)", \
         "datos/comparacion_ldos.dat" u 1:3 with lines lc rgb "red" title "Inciso B (Ancha)"

unset multiplot
unset output

print ">> PDF actualizado en graficos/Comparacion_Inciso_AB.pdf"

# =============================================================================
# 2. VISUALIZACIÓN EN PANTALLA
# =============================================================================
set term wxt size 1000,500 enhanced font 'Sans,10' persist title "Vista Previa"

set multiplot layout 1,2 title "Vista en Pantalla: Inciso A vs B" font ",14"

    # --- GRAFICO 1 (Pantalla) ---
    set title "Decaimiento de Probabilidad P(t)"
    set xlabel "Tiempo (t)"
    set ylabel "Probabilidad"
    set key top right
    
    # Rango tiempo
    set xrange [0:5]
    
    plot "datos/comparacion_probabilidad.dat" u 1:2 w l ls 1 title "Inciso A", \
         "datos/comparacion_probabilidad.dat" u 1:3 w l ls 2 title "Inciso B"

    # --- GRAFICO 2 (Pantalla) ---
    set title "Ensanchamiento de la LDOS"
    set xlabel "Energía (E)"
    set ylabel "Densidad de Estados"
    
    # Rango energía
    set xrange [-5:5]
    
    plot "datos/comparacion_ldos.dat" u 1:2 with lines lw 2 lc rgb "blue" title "Inciso A", \
         "datos/comparacion_ldos.dat" u 1:3 with lines lw 2 lc rgb "red" title "Inciso B"

unset multiplot

print ">> Gráfico en pantalla. Presiona ENTER para salir."
pause -1