#!/bin/bash -l
# -*- coding: utf-8 -*-
# PBS -N merge_monthly_to_yearly
# PBS -A UCOR0076
# PBS -l select=1:ncpus=1:mem=4GB
# PBS -l walltime=02:00:00
# PBS -q casper
# PBS -j oe

module load cdo

INPUT_DIR="/glade/work/xliu1/era5_regrid"
OUTPUT_DIR="/glade/work/xliu1/era5_yearly"
mkdir -p "$OUTPUT_DIR"

# Variables of interest
VAR_KEYWORDS=("2t" "2d" "sd" "ci" "tp")

# ensure globs that don't match produce empty arrays instead of literal patterns
shopt -s nullglob

# Loop over years
for year in {1940..2025}; do
    for kw in "${VAR_KEYWORDS[@]}"; do

        # collect files and filter to those fully inside the year
        matches=()
        for f in "$INPUT_DIR"/*"$kw"*.nc; do
            base=$(basename "$f")
            # extract the start and end timestamps (10 digits each, e.g. 2010010100)
            start=$(echo "$base" | sed -E 's/.*([0-9]{10})_[0-9]{10}.*/\1/')
            end=$(echo   "$base" | sed -E 's/.*[0-9]{10}_([0-9]{10}).*/\1/')
            if [[ ${start:0:4} -eq $year && ${end:0:4} -eq $year ]]; then
                matches+=("$f")
            fi
        done

        if [ ${#matches[@]} -eq 0 ]; then
            echo "No files found for $kw in $year"
            continue
        fi

        # sort matches to ensure correct temporal order
        mapfile -t sorted_matches < <(printf '%s\n' "${matches[@]}" | sort)
        matches=( "${sorted_matches[@]}" )

        # use first file as template, replace timestamp span with just the year
        first_file_basename=$(basename "${matches[0]}")
        out_file_name=$(printf '%s' "$first_file_basename" \
            | sed -E "s/[0-9]{10}_[0-9]{10}/${year}/")

        out_file="$OUTPUT_DIR/$out_file_name"

        if [ ! -f "$out_file" ]; then
            echo "Merging $kw for $year -> $out_file_name ..."
            cdo mergetime "${matches[@]}" "$out_file"
            echo "Created: $out_file"
        else
            echo "Yearly file already exists: $out_file"
        fi
    done
done

shopt -u nullglob

echo "All monthly files merged into yearly NetCDFs."