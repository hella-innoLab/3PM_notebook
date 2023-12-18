#!/bin/bash

#
# calculation of 5-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#


sky_subdiv=1
# use 4 (i.e. misc/sky_glow1_rein4.rad) for a more detailed description of the sky

# get number of CPUs available
nprocs=$( nproc)

printf "\n\n 5PM direct daylight matrix calculation\n"

#rcopts=" -V- -n ${nprocs} -w- -ab 0 -ad 1024 -lw 1.0e-6 -faa "
rcopts=" -V- -n ${nprocs} -w- -ab 0 -ad 512 -lw 1.0e-6 -faa -c 1450 " # low to show...

printf " calculate direct daylight matrix... \n"
time rfluxmtx ${rcopts} \
     scene/tutorial_window_dmx_dummy.rad misc/sky_glow1_rein${sky_subdiv}.rad \
     scene/tutorial_room_5pm_black.rad > matrices/tutorial_room_5pm_rein${sky_subdiv}.ddmx

printf " ... done.\n"



