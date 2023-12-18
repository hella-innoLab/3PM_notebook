#!/bin/bash

#
# calculation of 5-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

# get number of CPUs available
nprocs=$( nproc)

printf "\n\n 5PM direct view matrix calculation ... \n"

#rcopts=" -V- -n ${nprocs} -w- -I+ -ab 1 -ad 65536 -lw 1.0e-6 -faa "
rcopts=" -V- -n ${nprocs} -w- -I+ -ab 1 -ad 8192 -lw 1.0e-6 -faa " # low to show

printf " calculate direct view matrix... \n"
time rfluxmtx ${rcopts} < pts/tutorial_workplane.pts - scene/tutorial_window_vmx_glow.rad  \
     scene/tutorial_room_5pm_black.rad > matrices/tutorial_room_5pm_sensors.dvmx

printf " ... done.\n"

