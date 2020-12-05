import xarray as xr
import fcluster as fcl
import numpy as np


class ClusterArray(object):
    """
    This class takes a 2D xarray.DataArray as input.
    Dimensions must be x and y.
    """
    def __init__(self, indata, threshold):
        self.indata = indata
        self.threshold = threshold
        self.clusterdata = xr.where(self.indata.copy(deep=True) > -99999999999999, -1, -1)

    def _create_mask(self):
        return xr.where(self.indata >= self.threshold, 1, 0)

    def get_clusterarray(self):
        mask = self._create_mask()
        cells = fcl.clustering(indata=self.indata.values,
                               mask=mask.values, nx=self.indata.sizes['x'], ny=self.indata.sizes['y'])
        cells = cells[np.newaxis, ...]
        self.clusterdata.values = cells
        return self.clusterdata
