#!/bin/bash -l
#PBS -N regrid_seaice
#PBS -A UCOR0076
#PBS -l select=1:ncpus=1:mem=4GB
#PBS -l walltime=02:00:00
#PBS -q casper
#PBS -j oe

# Load CDO module
module load cdo

# Directories
INPUT_DIR="/glade/derecho/scratch/adixit/India_Heatwave/DATA/era5_data/tp"
OUTPUT_DIR="/glade/work/xliu1/era5_yearly_regrid"
mkdir -p "$OUTPUT_DIR"

# Create a 1-degree target grid for 30-90N
GRID_FILE="$OUTPUT_DIR/era5_latlon.txt"
cat > "$GRID_FILE" <<EOL
gridtype = lonlat
xsize = 360
ysize = 60
xfirst = -179.5
xinc = 1.0
yfirst = 30.5
yinc = 1.0
EOL

# Loop over all NetCDF files
for f in "$INPUT_DIR"/*.nc; do
    filename=$(basename "$f" .nc)

    # Define output file path (just add _1deg to original name)
    output_file="$OUTPUT_DIR/${filename}_1deg.nc"

    # Skip if already processed
    if [ -f "$output_file" ]; then
        echo "Already processed: $output_file"
        continue
    fi

    echo "Processing $f..."

    # Subset to 30-90N and regrid to 1° × 1°
    cdo remapbil,"$GRID_FILE" -sellonlatbox,-180,180,30,90 "$f" "$output_file"

done

echo "All files processed."