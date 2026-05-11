#!/bin/bash -l
#PBS -N CESM2_vert_sum_vsnon
#PBS -A UCOR0076
#PBS -l select=1:ncpus=1:mem=8GB
#PBS -l walltime=04:00:00
#PBS -q casper
#PBS -j oe

module load cdo

INPUT_DIR="/glade/work/xliu1/cesm2_sosi_regrid"
OUTPUT_DIR="/glade/work/xliu1/cesm2_sosi_nc_sum"
mkdir -p "$OUTPUT_DIR"

echo "Summing vsnon_d across nc=5 layers..."

for f in "$INPUT_DIR"/*vsnon_d*1deg.nc; do
    filename=$(basename "$f" .nc)
    summed_file="$OUTPUT_DIR/${filename}_ncSum.nc"

    # Skip if already processed
    if [ -f "$summed_file" ]; then
        echo "Already done: $summed_file"
        continue
    fi

    echo "Processing: $filename"

    # Remove any stale temp file
    rm -f "$summed_file"

    # Sum the 5 sea ice categories (nc dimension)
    cdo -f nc4c vertsum "$f" "$summed_file"

    echo "Created: $summed_file"
done

echo "✅ All files completed."