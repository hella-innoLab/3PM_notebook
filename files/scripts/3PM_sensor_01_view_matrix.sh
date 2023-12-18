#!/bin/bash

#
# calculation of 3-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

# get number of CPUs available
nprocs=$( nproc)

printf "\n\n 3PM view matrix calculation ... \n"

#rcopts=" -V- -n ${nprocs} -w- -I+ -ab 5 -ad 65536 -lw 1.0e-6 -faa "
rcopts=" -V- -n ${nprocs} -w- -I+ -ab 3 -ad 8192 -lw 1.0e-6 -faa " # low to show...

printf " workplane sensors... \n"
time rfluxmtx ${rcopts} < pts/tutorial_workplane.pts - scene/tutorial_window_vmx_glow.rad  \
     scene/tutorial_room_3pm.rad > matrices/tutorial_room_3pm_sensors.vmx

printf " ... done.\n"


"rfluxmtx -V- -n 2 -w- -I+ -ab 3 -ad 8192 -lw 1.0e-6 -faa < pts/tutorial_workplane.pts - scene/tutorial_window_vmx_glow.rad  scene/tutorial_room_3pm.rad > matrices/tutorial_room_3pm_sensors.vmx"
