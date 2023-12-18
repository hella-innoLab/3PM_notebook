#!/bin/bash

#
# calculation of 5-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

#res=500
res=250 # low to show...

printf "\n\n 5PM material map 1 (for direct view matrix)... \n"
oconv -w scene/tutorial_window_vmx_glow_img.rad scene/tutorial_room_3pm.rad > oct/tutorial_room_reflmap_M1.oct
rpict -x ${res} -y ${res} -ps 1 -av 0.31831 0.31831 0.31831 -ab 0 -vf view/view_fish_p01.vf oct/tutorial_room_reflmap_M1.oct \
  > matrices/img_reflmaps/tutorial_room_reflmap_M1.hdr

printf "\n 5PM material map 2 (for direct sun matrix)... \n"
oconv -w scene/tutorial_window_vmx_sun_black.rad scene/tutorial_room_3pm.rad > oct/tutorial_room_reflmap_M2.oct
rpict -x ${res} -y ${res} -ps 1 -av 0.31831 0.31831 0.31831 -ab 0 -vf view/view_fish_p01.vf oct/tutorial_room_reflmap_M2.oct \
  > matrices/img_reflmaps/tutorial_room_reflmap_M2.hdr

printf "\n done ... \n"

