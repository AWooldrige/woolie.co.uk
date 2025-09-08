#!/usr/bin/env bash
set -eux

function filename_safe() {
    printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr ' ' '-' \
    | tr -cd '[:alnum:]_-'
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dir=$1

if [ ! -d "$dir" ]; then
    echo "Error: $dir is not a directory"
    exit 1
fi

outdir="${dir}/output"
mkdir -p "$outdir"

read -p "Submission year (e.g. 2025): " sb_year
read -p "Submission month (e.g. 08): " sb_month
read -p "Submission name (e.g. Julie): " sb_name
read -p "Submission model (e.g. Silvercool B2 39108UK): " sb_model

sb_fname_prefix=$(filename_safe "${sb_year}-${sb_month}-${sb_name}-${sb_model}")


set -- $(find "$dir" -type f \( -iname '*.jpg' -o -iname '*.jpeg' \))
for file do
    echo ""
    echo "Processing: $file"
    read -p "Image description (e.g. Window adapter from plastic): " sb_image_descr
    echo "$sb_image_descr"
    sb_fname_image=$(filename_safe "${sb_fname_prefix}-${sb_image_descr}")

    # Remove geotags/location data + rotate based on EXIF (before stripping it)
    convert "$file" -auto-orient -strip "$outdir/${sb_fname_image}.jpg"
    cat >"$outdir/${sb_fname_image}.yaml" <<EOL
---
title: ${sb_image_descr} (${sb_model} / ${sb_name} / ${sb_year} / ${sb_month})
caption: ${sb_image_descr}
---
EOL
done

