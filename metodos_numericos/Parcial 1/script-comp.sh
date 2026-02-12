#!/bin/bash
gfortran ./modulos/mod-isoprec.f90 \
			./modulos/mod-funciones.f90 \
			./modulos/mod-metodos.f90 \
			parcial1.f90 -o parcial1.x \
			mcd.f90 -o mcd.x
echo
