#!/bin/bash -l
# PBS -N CESM2_regrid_trefht_smbb
# PBS -A UCOR0076
# PBS -l select=1:ncpus=1:mem=8GB
# PBS -l walltime=04:00:00
# PBS -q casper
# PBS -j oe

module load netcdf
module load nco
module load conda

# Activate Conda environment with xesmf/esmpy
conda activate regrid

INPUT_DIR="/glade/campaign/cgd/cesm/CESM2-LE/atm/proc/tseries/day_1/TREFHT/"
OUTPUT_DIR="/glade/work/xliu1/cesm2_airtemp_regrid"
mkdir -p "$OUTPUT_DIR"

PYTHON_BIN="$(which python)"

echo "Processing CESM2 SMBB air temperature (TREFHT) files..."

for f in "$INPUT_DIR"/*smbb*.nc; do
    if [ ! -f "$f" ]; then
        echo "No SMBB TREFHT files found in $INPUT_DIR"
        break
    fi

    filename=$(basename "$f" .nc)
    output_file="$OUTPUT_DIR/${filename}_TREFHT_1deg.nc"

    # Skip if already processed
    if [ -f "$output_file" ]; then
        echo "Already processed: $output_file"
        continue
    fi

    echo "Processing file: $filename"
    "$PYTHON_BIN" "$OUTPUT_DIR/cesm2_airtemp_regrid.py" "$f" "$OUTPUT_DIR" "$filename"
done

echo "All CESM2 SMBB air temperature (TREFHT) files processed."
