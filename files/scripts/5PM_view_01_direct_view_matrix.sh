#!/bin/bash

#
# calculation of 5-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

# get number of CPUs available
nprocs=$( nproc)

printf "\n\n 5PM direct view matrix calculation ... \n"


#rcopts=" -V- -n ${nprocs} -w- -i -ab 1 -ad 16384 -lw 1.0e-6 -ffc "
#res=500
rcopts=" -V- -n ${nprocs} -w- -i -ab 1 -ad 1024 -lw 1.0e-6 -ffc " # low to show...
res=250

printf " Tutorial Room - view towards east ... \n"
vwrays -ff -vf view/view_fish_p01.vf  -x ${res} -y ${res} | \
       rfluxmtx ${rcopts} `vwrays -vf view/view_fish_p01.vf -x ${res} -y ${res} -d` - \
       scene/tutorial_window_vmx_glow_img_dir.rad scene/tutorial_room_5pm_black.rad


printf " ... done.\n"

