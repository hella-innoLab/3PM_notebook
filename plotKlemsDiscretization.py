from matplotlib.patches import Wedge
from matplotlib.collections import PatchCollection
import matplotlib.pyplot as plt
import numpy as np

def calcXY(theta, phi, r=1):
    theta_rad = np.deg2rad(theta)
    phi_rad = np.deg2rad(phi)
    x = -r * np.sin(theta_rad) * np.cos(phi_rad)
    y = -r * np.sin(theta_rad) * np.sin(phi_rad)
    return (x,y)

def plotRGB(mat, row=0, rgb='all', is_matrix: bool = False):
    
    if is_matrix:
        fig = plt.figure()
        ax = fig.add_subplot(131,aspect='equal')
        plotKlemsDisc(mat[:,0], ax= ax)
        
        ax = fig.add_subplot(132,aspect='equal')
        plotKlemsDisc(mat[:,1], ax= ax)
        
        ax = fig.add_subplot(133,aspect='equal')
        plotKlemsDisc(mat[:,2], ax= ax)
        
    else:
        if rgb == 'all':
            fig = plt.figure()
            ax = fig.add_subplot(131,aspect='equal')
            plotKlemsDisc(extract_data(mat, row, rgb='r'), ax= ax)
            
            ax = fig.add_subplot(132,aspect='equal')
            plotKlemsDisc(extract_data(mat, row, rgb='g'), ax= ax)
            
            ax = fig.add_subplot(133,aspect='equal')
            plotKlemsDisc(extract_data(mat, row, rgb='b'), ax= ax)
        
        else:
            fig = plt.figure()
            ax = fig.add_subplot(111,aspect='equal')
            plotKlemsDisc(mat, row=row, rgb=rgb, ax= ax)
    
def extract_data(mat, row, rgb):
    n = 146
    if rgb == 'r':
        values = mat[row,:n]
    elif rgb == 'g':
        values = mat[row,n:n*2]
    elif rgb == 'b':
        values = mat[row,n*2:n*3]
    
    return values

def plotKlemsDisc(data, ax, norm= False, cmax = None):
    if cmax:
        values_max = cmax
    else:
        values_max = np.max(data)
    
    theta = np.array([0, 5,15,25,35,45,55,65,75,90])
    phi_diff = np.array([1,8,16,20,24,24,24,16,12])

    pi = 0 
    patches = []
    for thetai in range(9):
        theta_start_temp = theta[thetai]
        theta_end_temp = theta[thetai+1]
        phi_diff_temp = phi_diff[thetai]
    
        
        phi_delta_temp = 360/phi_diff_temp
        phi_temp = -np.arange(0-phi_delta_temp/2,360,phi_delta_temp)
        for phii in range(phi_diff_temp):
            phi_start_temp = phi_temp[phii]
            phi_end_temp = phi_temp[phii+1]
            
            
            r_end_temp = calcXY(theta_end_temp, 0)[0]
            r_start_temp = calcXY(theta_start_temp, 0)[0]
            path_width_temp = r_end_temp - r_start_temp
            
            wedge_temp = Wedge((.0,.0), r_end_temp, phi_end_temp, phi_start_temp, width=path_width_temp)
    
            
            patches.append(wedge_temp)
            
            pi+=1
            
            phi_tempp = (phi_start_temp+phi_end_temp)/2
            r_temp = r_end_temp-path_width_temp/2
            x_temp = r_temp * np.cos(np.deg2rad(phi_tempp))
            y_temp = r_temp * np.sin(np.deg2rad(phi_tempp))
            ax.text(x_temp, y_temp, pi)
    
    
    p = PatchCollection(patches, cmap='Blues')
    p.set_clim([0, values_max])
    if norm:
        p.set_array(np.array(data/values_max))
    else:
        p.set_array(np.array(data))
    
    ax.add_collection(p)
    ax.set(xlim = [-1,1], ylim = [-1,1])
    ax.axis('off')
