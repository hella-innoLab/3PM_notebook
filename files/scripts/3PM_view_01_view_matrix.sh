#!/bin/bash

#
# calculation of 3-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

# get number of CPUs available
nprocs=$( nproc)

printf "\n\n 3PM view matrix calculation ... \n"

# low setting to be fast to show
rcopts=" -V- -n ${nprocs} -w- -ab 2 -ad 1024 -lw 1.0e-6 -ffc " # low to show...
res=250
#rcopts=" -V- -n ${nprocs} -w- -ab 5 -ad 16384 -lw 1.0e-6 -ffc "
#res=500

printf " Tutorial Room - view towards east ... \n"
vwrays -ff -vf view/view_fish_p01.vf  -x ${res} -y ${res} | \
       rfluxmtx ${rcopts} `vwrays -vf view/view_fish_p01.vf -x ${res} -y ${res} -d` - \
       scene/tutorial_window_vmx_glow_img.rad scene/tutorial_room_3pm.rad


printf " ... done.\n"