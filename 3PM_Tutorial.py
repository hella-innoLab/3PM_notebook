import os # provides functions for interacting with the operating system
import pyradiance as pr # python implementation of RADIANCE
import subprocess as sp # running shell commands
import pandas as pd # data analysis and manipulation tool
import matplotlib.pyplot as plt # library for creating static, animated, and interactive visualizations
import numpy as np # scientific computing
from pyradiance.anci import BINPATH # path to compiled .c RADIANCE programs
from pathlib import Path

nprocs = os.cpu_count()
cwd = os.getcwd() # get the current working directory
files_path = os.path.join(cwd, 'files') # path to the folder containing the files
sensor_file_path = os.path.join(files_path,'pts','seminarraum.pts')
sender_file_path = Path(f"{files_path}/scene/seminarraum_vmx_glow.rad")

'''
create sensor path
'''
pts_x = np.arange(0.1, 9.9, 0.5)
pts_y = np.arange(0.1, 6.1, 0.5)
pts = np.array([[x, y, 0.5, 0, 0, 1] for x in pts_x for y in pts_y])

np.savetxt(sensor_file_path, pts, fmt='%1.2f')


'''
Calc vmx matrices
'''
vmx_file_path = Path(f"{files_path}/matrices/seminarraum.vmx")
scene_file_path = Path(f"{files_path}/scene/seminarraum_scene.rad")


rcopts = f"-V- -n {nprocs} -w- -I+ -ab 5 -ad 65536 -lw 1.0e-6 -faa"
cmd = f"{BINPATH}/rfluxmtx {rcopts} < {sensor_file_path} - {sender_file_path} {scene_file_path} > {vmx_file_path}"
os.system(cmd)


'''
Calc dmx matrices
'''
sky_subdiv = 4

window_file_path = Path(f"{files_path}/scene/seminarraum_dmx_dummy.rad")

glow1_rein_file_path = Path(f"{files_path}/misc/sky_glow1_rein{sky_subdiv}.rad")
room_mat_file_path = Path(f"{files_path}/mat/seminarraum.mat")
room_file_path = Path(f"{files_path}/scene/seminarraum.rad")

dmx_file_path = Path(f"{files_path}/matrices/seminarraum.dmx")

rcopts = f"-V- -n {nprocs} -w- -ab 2 -ad 512 -lw 1.0e-6 -faa -c 1450"
cmd = f"{BINPATH}/rfluxmtx {rcopts} {window_file_path} {glow1_rein_file_path} {room_mat_file_path} {room_file_path} > {dmx_file_path}"
os.system(cmd)


'''
Calc sky matrix for one day in ibk
'''
def epw2wea(epw_file, file_out):
    epw_data = pd.read_csv(epw_file_path, header=None, skiprows=8)
    
    with open(epw_file,"r") as file:
        line_temp = file.readline()
    line_split = line_temp.split(",")
    
    month = epw_data[1].values
    day = epw_data[2].values
    hour = epw_data[3].values
    dir_nor_rad = epw_data[14].values
    diff_hor_rad = epw_data[15].values
    
    site_elevation = line_split[-1].split('\n')[0]
    #TODO: timezone is wrong
    time_zone = 70-float(line_split[8])
    
    header = ""
    header += f"place {line_split[1]}_{line_split[3]}\n"
    header += f"latitude {line_split[6]}\n"
    header += f"longitude {-(float(line_split[7]))}\n"
    header += f"time_zone {time_zone}\n" 
    header += f"site_elevation {site_elevation}\n"
    header += f"weather_data_file_units 1\n"

    with open(file_out, 'w') as file:
        file.write(header)
        for m, d, h, dnr, dhr in zip(month, day, hour, dir_nor_rad, diff_hor_rad):
            file.write(f'{m} {d} {h-0.5} {dnr} {dhr}\n')


epw_file_path = os.path.join(files_path, 'weather', 'AUT_TR_Innsbruck.AP.111200_TMYx.epw')

# epw_file_path = Path(f"{files_path}/weather/USA_NY_New.York-Central.Park.725033_TMY3.epw")
wea_file_path = Path(f"{files_path}/weather/IBK_sky.wea")
wea_selection_file_path = Path(f"{files_path}/weather/IBK_sky_day01.wea")
smx_file_path = Path(f"{files_path}/weather/IBK_sky_day01.smx")

epw2wea(epw_file_path, wea_file_path)

# select 18.06. to show
lines_n = 30
with open(wea_file_path, "r") as file_in , open(wea_selection_file_path, 'w') as file_out:  
    wea_lines = file_in.readlines()
    wea_header = wea_lines[:6]
    wea_data = wea_lines[6:]
    index_start = [i for i, line in enumerate(wea_data) if '6 18 0' in line][0]
    [file_out.write(h) for h in wea_header]
    for i in range(index_start, index_start+lines_n-1):
        line = wea_data[i]
        file_out.write(line)
        
#gendaymtx - generate an annual Perez sky matrix from a weather tape
cmd = f"{BINPATH}/gendaymtx -m {sky_subdiv} {wea_selection_file_path} > {smx_file_path}"
os.system(cmd)


'''

'''
bsdf_file_path = os.path.join(files_path, 'BSDF', 'blinds_20deg_Klems.xml')
result_file_path = Path(f"{files_path}/result/seminarraum_test.dat")
illum_file_path = Path(f"{files_path}/result/seminarraum.ill")


cmd = f"{BINPATH}/dctimestep {vmx_file_path} {bsdf_file_path} {dmx_file_path} {smx_file_path} > {result_file_path}"

os.system(cmd)

cmd = f"{BINPATH}/rmtxop -fa -c 47.448 119.951 11.601 -t {result_file_path} > {illum_file_path}"

os.system(cmd)


# plot illuminance time series along the room
header_n = 12
with open(illum_file_path) as f:
    data = f.readlines()[header_n:]

    data_matrix = np.vstack([np.array([float(v) for v in d.split()]) for d in data])

# plot time series of illuminance at point 44 and 30 (used before)


# ind_pts0 = 97
# ind_pts1 = 262
ind_pts0 = 91
ind_pts1 = 102

fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(data_matrix[:,ind_pts0], label=f'{ind_pts0}')
ax.plot(data_matrix[:,ind_pts1], label=f'{ind_pts1}')
ax.set(xlabel='Time', ylabel='Illuminance in lx')
ax.legend()


x_n = pts_x.size
y_n = pts_y.size
data_noon = data_matrix[12,:].reshape(x_n,y_n)
x_, y_ = np.meshgrid(pts_x, pts_y)

fig = plt.figure()
ax = fig.add_axes([0.1,0.1,0.5,0.8], aspect='equal')
cax = fig.add_axes([0.7,0.1,0.02,0.8])
cplot = ax.contourf(pts_x,pts_y,data_noon.T, cmap='jet')
ax.plot(x_.flatten(), y_.flatten(), 'k.')
ax.set(xlabel='x in m', ylabel='x in m')
fig.colorbar(cplot, cax=cax)
cax.set_ylabel('Illuminance in lx')



print("the end")