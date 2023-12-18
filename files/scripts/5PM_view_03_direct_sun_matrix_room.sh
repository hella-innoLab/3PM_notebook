#!/bin/bash

#
# calculation of 5-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

# specify number of sun positions to use (2 -> 577; 4 -> 2305; 6 -> 5185)
# use 6 for a more accurate description of the sun positions
mf_sun_pos=2
num_sun_pos=$( ev 144*${mf_sun_pos}*${mf_sun_pos}+1 )


# get number of CPUs available
nprocs=$( nproc)

#rcopts=" -V- -n ${nprocs} -w- -i -ab 1 -ad 16384 -lw 1.0e-6 -ffc "
#res=500
rcopts=" -V- -n ${nprocs} -w- -i -ab 1 -ad 512 -lw 1.0e-6 -ffc " # low to show...
res=250

# generate suns at patch positions
printf "\n generating suns - we assume we have that from the sensor calculation ... \n"
# printf "\n generating suns ... \n"
# printf "#@rfluxmtx h=r${mf_sun_pos} u=Y\n" > misc/suns_rein${mf_sun_pos}.rad
# printf "void light solar 0 0 3 1e6 1e6 1e6\n" >> misc/suns_rein${mf_sun_pos}.rad
#
# cnt ${num_sun_pos}  |  rcalc -e MF:${mf_sun_pos} -f reinsrc.cal -e Rbin=recno \
#                        -o 'solar source sun 0 0 4 ${ Dx } ${ Dy } ${ Dz } 0.5' >> misc/suns_rein${mf_sun_pos}.rad

printf "\n\n 5PM direct sun coefficient matrix calculation ... \n"

for var in blinds_20deg_BSDF blinds_20deg_geom ; do

  octree=oct/tutorial_room_5pm_dsunmx_${var}.oct
  oconv -w misc/suns_rein${mf_sun_pos}.rad scene/tutorial_room_5pm_dsunmx_${var}.rad  > ${octree}

  printf " calculate direct sun matrix room for system ${var}... \n"
  time vwrays -ff -vf view/view_fish_p01.vf  -x ${res} -y ${res} | \
    rcontrib ${rcopts} `vwrays -vf view/view_fish_p01.vf -x ${res} -y ${res} -d` \
    -o matrices/img_vmx_sun_room/tutorial_room_${var}_%04d.hdr -e MF:${mf_sun_pos} -f reinhart.cal -b rbin -bn Nrbins -m solar ${octree}
done

printf " ... done.\n"

