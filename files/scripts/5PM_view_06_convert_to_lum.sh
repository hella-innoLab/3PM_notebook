#!/bin/bash

#
# calculation of 5-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#


printf " 3PM direct contribution - convert illum to lum ... \n"

for img in matrices/img_vmx_dir/*.hdr; do
  img_b=$(basename ${img} .hdr)
  pcomb -h -e 'ro=ri(1)*ri(2);go=gi(1)*gi(2);bo=bi(1)*bi(2)' \
        -o matrices/img_reflmaps/tutorial_room_reflmap_M1.hdr -o ${img} \
        > matrices/img_vmx_dir_lum/${img_b}_lum.hdr
done


printf " 5PM direct contribution - convert illum to lum for room and add facade... \n"

for img in matrices/img_vmx_sun_room/*.hdr; do
  img_b=$(basename ${img} .hdr)
  pcomb -h -e 'ro=ri(1)*ri(2)+ri(3);go=gi(1)*gi(2)+gi(3);bo=bi(1)*bi(2)+bi(3)' \
  -o matrices/img_reflmaps/tutorial_room_reflmap_M2.hdr -o ${img} -o matrices/img_vmx_sun_fac/${img_b}.hdr \
  > matrices/img_vmx_sun_all/${img_b}.hdr
done
