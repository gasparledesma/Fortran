####################    Superficie 3D: Cruces Evitados   ####################
reset
set term wxt persist size 900,700 font "Sans,10"
set title "Superficie de Densidad de Estados (Cruces Evitados)"
set xlabel 'Desintonía x' offset 0,-1
set ylabel 'Frecuencia w^2' offset 0,-1
set zlabel 'Densidad {/Symbol r}' offset 1,0
set grid

# CONFIGURACIÓN 3D 
set pm3d           # coloreado de la superficie
set style data pm3d
set pm3d depthorder # Dibuja lo de atrás primero (evita errores visuales)
set ticslevel 0    # Hace que se vea desde arriba o como que lo pega en el plano xy (z=0)
set view 60, 30    # Ángulo de la cámara (rotación X, rotación Z)

                   
set palette rgbformulae 33,13,10  # Colores cálidos
set samples 60     # Resolución en X (menos puntos = red más abierta)
set isosamples 60  # Resolución en Y

# Rangos
set xrange [-2:2]
set yrange [4:11]
set zrange [0:4]   # Cortamos los picos muy altos para ver mejor la base

#### PARÁMETROS  #######
i = {0.0, 1.0}
pi = 3.1415926535
w1 = 6.0
wi = 9.0
V = 1.0
eta = 0.1  

# Acoplamientos

V1i = V
Vi2 = V
Vi1 = V 
V2i = V

# Funciones de Green
pos_w2(x_des) = w1 + x_des

G11(w, x) = 1.0 / (w - w1 + i*eta - (V1i*Vi1 / (w - wi + i*eta - (V2i*Vi2 / (w - pos_w2(x) + i*eta)))))
Gii(w, x) = 1.0 / (w - wi + i*eta - (Vi1*V1i / (w - w1 + i*eta)) - (Vi2*V2i / (w - pos_w2(x) + i*eta)))
G22(w, x) = 1.0 / (w - pos_w2(x) + i*eta - (V2i*Vi2 / (w - wi + i*eta - (V1i*Vi1 / (w - w1 + i*eta)))))

rho_tot(x_param, w_val) = (-1.0/pi) * imag( G11(w_val, x_param) + Gii(w_val, x_param) + G22(w_val, x_param) )

# --- GRAFICAR ---
# Usamos 'with pm3d' para superficie sólida o 'with lines' para malla de alambre
splot rho_tot(x, y) with pm3d border lc "black" lw 0.5 title ""

###################################  Exportar a PDF ##########################
set terminal pdfcairo enhanced font 'Sans,12' size 8in,6in
set output "superficie_3d_cruces.pdf"
replot
unset output
## se ve que no se hace un pdf xq en gnuplot te deja mover el grafico, tiene sentido que no se genere un pdf entonces
## pero con el grafico que hace el archivo curvas_nivl.plt sirve para representar los cruces.