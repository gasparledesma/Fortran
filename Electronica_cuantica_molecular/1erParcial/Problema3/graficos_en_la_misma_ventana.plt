reset
set encoding utf8
set grid

# Habilitamos el uso de macros
set macros

# =============================================================================
# 1. CONFIGURACIÓN ÚNICA (Estilos y Comandos Guardados)
# =============================================================================

# Estilos de línea
set style line 1 lc rgb "red" lw 2    # Rojo
set style line 3 lc rgb "blue" lw 2   # Azul

# --- MACRO 1: Comandos para el gráfico de PROBABILIDAD ---
# Guardamos todo (títulos, ejes, rango y el plot) en una variable llamada 'grafico_prob'
grafico_prob = "set title 'Probabilidad de Supervivencia'; \
                set xlabel 'Tiempo (t)'; \
                set ylabel 'Probabilidad'; \
                set xrange [0:5]; \
                plot 'datos/comparacion_probabilidad.dat' u 1:2 w l ls 1 title 'Cadena de 1 rama inf', \
                     'datos/comparacion_probabilidad.dat' u 1:3 w l ls 3 title 'Cadena de 2 ramas inf'"

# --- MACRO 2: Comandos para el gráfico de LDOS ---
# Guardamos todo en una variable llamada 'grafico_ldos'
grafico_ldos = "set title 'Densidad de Estados (LDOS)'; \
                set xlabel 'Energía (E)'; \
                set ylabel 'Amplitud'; \
                set xrange [-5:5]; \
                plot 'datos/comparacion_ldos.dat' u 1:2 w l ls 1 title 'Cadena de 1 rama inf', \
                     'datos/comparacion_ldos.dat' u 1:3 w l ls 3 title 'Cadena de 2 ramas inf'"

# =============================================================================
# 2. SALIDA 1: ARCHIVO PDF
# =============================================================================
set term pdfcairo enhanced font 'Sans,12' size 6in,8in
set output "graficos/probabilidad_ldos.pdf"

set multiplot layout 2,1 title "Estados Resonantes y Regla de Oro de Fermi" font ",14"
    
    # Aquí ejecutamos las macros
    @grafico_prob
    @grafico_ldos

unset multiplot
unset output
print ">> PDF generado."

# =============================================================================
# 3. SALIDA 2: PANTALLA (WXT)
# =============================================================================
set term wxt persist size 600,800 font 'Sans,10' title "Resultados Problema 3"

set multiplot layout 2,1 title "Estados Resonantes y Regla de Oro de Fermi" font ",14"

    # Reutilizamos las mismas macros (¡No hay que reescribir nada!)
    @grafico_prob
    @grafico_ldos

unset multiplot
print ">> Gráficos en pantalla."