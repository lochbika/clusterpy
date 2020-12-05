import xarray as xr
import matplotlib.pyplot as plt
import numpy as np
from clusterpy import cluster

infile = '/home/kai/PycharmProjects/clusterpy/cape.surfprec.100_coarse.nc'
thres = 0.6/3600
 
ds_disk = xr.open_dataset(infile, decode_times=False)

t = 0
tslice = ds_disk.isel(time=t, x=range(ds_disk.sizes['x']), y=range(ds_disk.sizes['y'])).to_array()
cldata = xr.where(tslice > -999999999, -1, -1)

cells = cluster.ClusterArray(tslice,thres).get_clusterarray()

