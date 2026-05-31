#!/usr/bin/env bash
set -euo pipefail

if ! command -v convert >/dev/null 2>&1; then
    echo "Error: ImageMagick ('convert' command) is not installed."
    exit 1
fi

function filename_safe() {
    printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr ' ' '-' \
    | tr -cd '[:alnum:]_-' \
    | tr -s '-' # Squeeze consecutive hyphens into a single one
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

# Set up defaults for convenience
current_year=$(date +%Y)
current_month=$(date +%m)

# Ask for input with defaults
read -p "Submission year [${current_year}]: " sb_year
sb_year=${sb_year:-$current_year}

read -p "Submission month [${current_month}]: " sb_month
sb_month=${sb_month:-$current_month}

read -p "Submission name (e.g. Julie or 'anon') [anon]: " sb_name
sb_name=${sb_name:-anon}

# Ensure model is not left blank
sb_model=""
while [[ -z "$sb_model" ]]; do
    read -p "Submission model (e.g. Silvercool B2 39108UK): " sb_model
done

sb_fname_prefix=$(filename_safe "${sb_year}-${sb_month}-${sb_name}-${sb_model}")

# For handling spaces in filenames:
# Use process substitution and 'mapfile' to safely populate an array of files.
# Added -maxdepth 1 so it doesn't accidentally re-process images inside /output.
mapfile -d $'\0' image_files < <(find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' \) -print0)

if [ ${#image_files[@]} -eq 0 ]; then
    echo "No JPEG images found in $dir."
    exit 0
fi

for file in "${image_files[@]}"; do
    echo ""
    echo "Processing: $file"

    # Ensure description is not left blank
    sb_image_descr=""
    while [[ -z "$sb_image_descr" ]]; do
        read -p "Image description (e.g. Window adapter from plastic): " sb_image_descr
    done

    sb_fname_image=$(filename_safe "${sb_fname_prefix}-${sb_image_descr}")

    # Remove geotags/location data + rotate based on EXIF (before stripping it)
    convert "$file" -auto-orient -strip "$outdir/${sb_fname_image}.jpg"

    cat >"$outdir/${sb_fname_image}.yaml" <<EOL
---
title: "${sb_image_descr} (${sb_model} / ${sb_name} / ${sb_year} / ${sb_month})"
caption: "${sb_image_descr}"
---
EOL
done

echo ""
echo "Processing complete! Check the '$outdir' directory."
