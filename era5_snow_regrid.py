import sys
import dask
import xarray as xr
import xesmf as xe
import numpy as np
import pyproj

input_file  = sys.argv[1]
output_dir  = sys.argv[2]
filename    = sys.argv[3]
output_file = f"{output_dir}/{filename}_1deg.nc"

print("Opening dataset...")
ds = xr.open_dataset(input_file, decode_times=False, chunks={"time": 50})

# -----------------------------------------------------
# Convert projected EASE-grid coords → lat/lon
# -----------------------------------------------------
print("Converting projection coordinates to lat/lon...")
proj = pyproj.Proj(proj='laea', lat_0 = 90, lon_0 = 0, datum = 'WGS84')

xx, yy = np.meshgrid(ds['x'].values, ds['y'].values)
lon2d, lat2d = proj(xx, yy, inverse = True)

ds = ds.assign_coords({
    "lon": (("y", "x"), lon2d),
    "lat": (("y", "x"), lat2d)
})

# -----------------------------------------------------
# Target 1° grid
# -----------------------------------------------------
print("Defining 1° Arctic grid...")
lon = np.arange(-180, 180, 1)
lat = np.arange(30, 91, 1)

ds_out = xr.Dataset({
    "lat": (["lat"], lat, {"units": "degrees_north"}),
    "lon": (["lon"], lon, {"units": "degrees_east"})
})

# -----------------------------------------------------
# Build regridder
# -----------------------------------------------------
print("Building regridder...")
regridder = xe.Regridder(ds, ds_out, "bilinear", ignore_degenerate = True)

# -----------------------------------------------------
# Regrid
# -----------------------------------------------------
print("Regridding snow depth...")
snod_ll = regridder(ds["snod"], keep_attrs = True)

# -----------------------------------------------------
# Save
# -----------------------------------------------------
print("Saving file...")
snod_ll.to_netcdf(output_file)

print("Finished:", output_file)