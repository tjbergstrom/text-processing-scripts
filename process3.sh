#!/bin/bash

# $ bash process3.sh
#
# A good pre-processing step to rename all image files, get rid of weird internet filenames
# Renames everything to image_1.jpg image_2.png etc, preserving extensions
#
# Need to be very careful about renaming programmatically or you will accidentally delete lots of files
# This has been error checked fairly well so that bad things don't happen
# But still it is good to backup your datasets before running anything like this


cd ../original_dataset

# Manually define the directries - this can be done automatically, but want to be more careful
dirsArr=("test1" "test2")

# Err check that the directories exist before doing anything, can cause big problems
for val in "${!dirsArr[@]}"
do
    if [ ! -d "${dirsArr[$val]}" ]; then
        printf "Err: The directory original_dataset/"${dirsArr[$val]}" does not exist\m"
        exit 1
    fi
    # Also check for empty directories just because
    if [ ! "$(ls -A "${dirsArr[$val]}")" ]; then
        printf "Err: The directory original_dataset/"${dirsArr[$val]}" is empty\n"
        exit 1
    fi
done

for val in "${!dirsArr[@]}"
do
    # Make an empty temp directory - this implementation seems redundant but works better & safer
    rm -rf tmp_dir
    mkdir tmp_dir
    cd "${dirsArr[$val]}"
    printf "Processing "${dirsArr[$val]}" directory \n"
    printf "ls -U | head -5\n"
    ls -U | head -5
    itr=0
    # Loop through all files in this directory
    for img_file in *
    do
        # Get the extension
        ext=".${img_file##*.}"
        # Manually get the file type if there is no extension
        if [ $ext == ".$img_file" ]
            then
                if [[ $(file --mime-type -b "$img_file") == "image/png" ]]; then
                    ext=".png"
                elif [[ $(file --mime-type -b "$img_file") == "image/jpeg" ]]; then
                    ext=".jpg"
                else
                    ext=""
                fi
        fi
        # Copy to the temp directory, the renamed files are in the format /image_01.jpg
        # Err check that this file doesn't already exist, can really mess things up
        if [ -f "../tmp_dir/image_"${itr}""${ext}"" ]; then
            # Just move over the original file name seems to solve it
            cp "${img_file}" ../tmp_dir/$img_file
        else
            cp "${img_file}" ../tmp_dir/image_"${itr}""${ext}"
        fi
        itr=$((itr+1))
    done
    cd ..
    # Remove the original directory with the weird filenames and replace it with the temp
    rm -rf "${dirsArr[$val]}"
    mv tmp_dir "${dirsArr[$val]}"
    rm -rf tmpdir
    cd "${dirsArr[$val]}"
    printf "ls -U | head -5\n"
    ls -U | head -5
    printf "\n"
    cd ..
done



##
