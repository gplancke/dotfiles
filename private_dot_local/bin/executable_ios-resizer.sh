#!/bin/bash
# This script resizes input images to the Apple Store required dimensions.
# It requires ImageMagick to be installed (for the 'convert' command).

# Check for at least one argument.
if [ "$#" -lt 1 ]; then
	echo "Usage: $0 image1.png [image2.png ...]"
	exit 1
fi

# Define two sets of target sizes:
# Set 1 (iPhone 6.7"/6.9" previews):
set1=("1320x2868" "2868x1320" "1290x2796" "2796x1290")
# Set 2 (Alternative sizes):
set2=("1242x2688" "2688x1242" "1284x2778" "2778x1284")

# Create an output directory.
mkdir -p resized

# Process each image provided as an argument.
for image in "$@"; do
	if [ ! -f "$image" ]; then
		echo "File not found: $image"
		continue
	fi

	base=$(basename "$image")
	filename="${base%.*}"
	ext="${base##*.}"

	echo "Processing $image ..."

	# Generate outputs for the first set.
	for size in "${set1[@]}"; do
		output="resized/${filename}_set1_${size}.${ext}"
		# The "!" forces the exact dimensions (may distort if aspect ratios differ).
		convert "$image" -resize "${size}!" "$output"
		echo "Created: $output"
	done

	# Generate outputs for the second set.
	for size in "${set2[@]}"; do
		output="resized/${filename}_set2_${size}.${ext}"
		convert "$image" -resize "${size}!" "$output"
		echo "Created: $output"
	done
done

echo "All images processed."
