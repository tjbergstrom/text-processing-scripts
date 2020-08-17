#!/bin/bash

# For an image processing ML project.
# The directory had too many images,
# I just wanted to start with a smaller dataset to get my model started,
# And I needed a better mix of files, so it was important to get
# Every 10th file, rather than just grabbing the first thousand or so.
# And it's easier to do that with commands programmatically, as follows.

cd images
mkdir sample_images

files=$(ls)
echo $files | tr ' ' '\n' > files.txt

itr=0
input_file="files.txt"
while IFS= read -r line
do
    if [ ${itr} -eq 10 ]
        mv "${line}" sample_images/"${line}"
        itr=0
    else
        itr=$((itr+1))
    fi
done < $input_file


