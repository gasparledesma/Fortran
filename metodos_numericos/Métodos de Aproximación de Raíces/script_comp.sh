#!/bin/bash
gfortran ./modulos/mod_isoprec.f90 \
	./modulos/mod_funciones.f90 \
	./modulos/mod_metodos.f90 \
	./programa.f90 -o raices.x
echo
