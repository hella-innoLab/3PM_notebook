import numpy as np 
import matplotlib.pyplot as plt
import sys,os

from plotKlemsDiscretization import plotKlemsDisc

matrices_path = os.path.join(os.path.dirname(__file__), '3PM_notebook','files','matrices')

p1, p2 = 40, 33

# Load the data
vmx_file_path = os.path.join(matrices_path, 'tutorial_room_3pm_sensors_temp.vmx')
with open(vmx_file_path) as f:
    vmx_data = f.readlines()[10:]


data_p1 = np.array([float(v) for v in vmx_data[p1].split()])
data_p2 = np.array([float(v) for v in vmx_data[p2].split()])

data_p1_mat = np.reshape(data_p1, (145, 3))
data_p2_mat = np.reshape(data_p2, (145, 3))

data_p1_R = data_p1_mat[:,0]
data_p2_R = data_p2_mat[:,0]

c_max = np.max([np.max(data_p1_R), np.max(data_p2_R)])

# fig = plt.figure(figsize = (20,10))
# ax1 = fig.add_subplot(121,aspect='equal')
# plotKlemsDisc(data_p1_mat[:,0], ax1, norm=False, cmax=c_max)
# ax1.set_title('Point 1: close to the window')

# ax2 = fig.add_subplot(122,aspect='equal')
# plotKlemsDisc(data_p2_mat[:,0], ax2, norm=False, cmax=c_max)
# ax2.set_title('Point 2: at the back of the room')


dmx_file_path = os.path.join(matrices_path, 'tutorial_room_3pm_rein1.dmx')
with open(dmx_file_path) as f:
    data_dmx = f.readlines()[11:]
    
dmx_matrix = np.vstack([np.array([float(v) for v in d.split()]) for d in data_dmx])


# center_patch_ind = 0
# data_center_patch = dmx_matrix[center_patch_ind,:]

# data_center_patch_matrix = np.reshape(data_center_patch, (146, 3))

# data_center_patch_matrix_R = data_center_patch_matrix[1:,0]


data_plot = dmx_matrix[:,112*3]

c_max = np.max(data_plot)

fig = plt.figure(figsize = (20,10))
ax1 = fig.add_subplot(111,aspect='equal')
plotKlemsDisc(data_plot, ax1, norm=False, cmax=c_max)

print("test")