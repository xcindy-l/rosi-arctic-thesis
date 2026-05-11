#!/bin/bash -l
#PBS -N regrid_rosi_2025
#PBS -A UCOR0076
#PBS -l select=1:ncpus=1:mem=4GB
#PBS -l walltime=04:00:00
#PBS -q casper
#PBS -j oe

module load cdo

INPUT_DIR="/glade/campaign/collections/rda/data/d633000/e5.oper.an.sfc/"
OUTPUT_DIR="/glade/work/xliu1/era5_regrid"
mkdir -p "$OUTPUT_DIR"

# 1-degree Arctic grid
GRID_FILE="$OUTPUT_DIR/ERA5_latlon.txt"
cat > "$GRID_FILE" <<EOL
gridtype = lonlat
xsize = 360
ysize = 60
xfirst = -179.5
xinc = 1.0
yfirst = 30.5
yinc = 1.0
EOL

# ROSI-relevant keywords (for filename filter)
VAR_KEYWORDS=("2t" "2d" "sd" "ci" "tp")

# Loop over monthly folders
for month_dir in "$INPUT_DIR"/??????; do
    for f in "$month_dir"/*.nc; do
        filename=$(basename "$f" .nc)
        filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
        daymean_file="$OUTPUT_DIR/${filename}_daymean_1deg.nc"

        # Quick filename check
        keep_file=false
        for kw in "${VAR_KEYWORDS[@]}"; do
            if [[ "$filename_lower" == *"$kw"* ]]; then
                keep_file=true
                break
            fi
        done

        if [ "$keep_file" = false ]; then
            echo "Skipping irrelevant file by name: $filename_lower"
            continue
        fi

        echo "Inspecting variables in $filename_lower..."

        # Python: find relevant variables
        VARS=$(/glade/u/apps/jupyterhub/jh-23.11/bin/python3 - <<EOF
import xarray as xr
ds = xr.open_dataset("$f")
keywords = ["2T", "2D", "SD", "CI", "TP"]
existing_vars = [v for v in ds.data_vars if any(k.upper() in v.upper() for k in keywords)]
print(','.join(existing_vars))
EOF
        )

        if [ -z "$VARS" ]; then
            echo "No relevant variables in $filename_lower, skipping."
            continue
        fi

        if [ ! -f "$daymean_file" ]; then
            echo "Processing $filename_lower with variables: $VARS"

            # Step 1: Daily mean
            tmp_daymean="$OUTPUT_DIR/${filename}_tmp_daymean.nc"
            cdo -selname,$VARS -daymean "$f" "$tmp_daymean"

            # Step 2: Subset Arctic + Regrid to 1°
            cdo -sellonlatbox,-180,180,30,90 \
                -remapbil,"$GRID_FILE" \
                "$tmp_daymean" "$daymean_file"

            rm -f "$tmp_daymean"
            echo "Created final daily mean regridded file: $daymean_file"
        else
            echo "Daily mean regridded file already exists: $daymean_file"
        fi

    done
done

echo "All ERA5 files processed with daily mean + regrid."