#!/bin/bash -l
#PBS -N ERA5_snow_regrid
#PBS -A UCOR0076
#PBS -l select=1:ncpus=2:mem=16GB
#PBS -l walltime=03:00:00
#PBS -q casper
#PBS -j oe

module load conda
module load esmf

conda activate regrid   # your working environment

INPUT_FILE="/glade/derecho/scratch/flehner/SM_snod_ERA5_01Aug1980-31Jul2021_v01.nc"
OUTPUT_DIR="/glade/work/xliu1/era5_snow_regrid"
PYTHON_SCRIPT="$OUTPUT_DIR/era5_snow_regrid.py"

mkdir -p "$OUTPUT_DIR"
filename=$(basename "$INPUT_FILE" .nc)

echo "Using Python from: $(which python)"
echo "Starting ERA5 snow regridding..."

python "$PYTHON_SCRIPT" "$INPUT_FILE" "$OUTPUT_DIR" "$filename"

echo "Done!"
