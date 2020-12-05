from numpy.distutils.core import setup, Extension

ext1 = Extension(name='fcluster',
                 sources=['clusterpy/fortran_cluster.f90'])

setup(
    name='clusterpy',
    version='0.1',
    url='https://github.com/lochbika/clusterpy',
    license='GNU General Public License v3.0',
    author='Kai Lochbihler',
    author_email='kai.lochbihler@gmx.de',
    description='A small package to cluster continous areas in 2D fields (xarray, netCDF) and assign unique IDs to them.'
                'It uses a fortran routine to speed up the clustering process.',
    ext_modules=[ext1],
    packages=['clusterpy']
)
