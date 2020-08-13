#!/bin/bash

# August 2020
# process.sh

# This script will loop through multiple .csv files in a directory
# And process them with the same Linux commands
# Mostly organizing the data (columns) with some text replacement
# And over-write the original files
# And print out a quick check of how the files resulted
#
# bash process.sh

# Assuming the original files have been manually added to this directory
cd signs

# Get all file names in the directory into a variable
files=$(ls)
# Place all of those file names into a file, separated by newline
echo $files | tr ' ' '\n' > files.txt

# Just quickly display what one of the files looks like before processing
printf "\nOriginal: \n"
# Get the first file
f=$(head -n 1 files.txt)
printf "\nhead "${f}"\n"
# Display the first ten lines from it
head ${f}

printf "\nBeginning to process these files: \n"
cat "files.txt"

# Read each of the files,
# by reading from the file of file names line by line
input_file="files.txt"
while IFS= read -r line
do
    # Process each file with Linux commands
    echo "Processing: $line"
    # Remove this one unwanted char from the whole file because it ruins columns
    sed -i 's/'Rx'/''/g' "${line}"
    # Remove unwanted columns
    awk -F "," '{print $1,$2,$3,$4,$5,$8}' $line > tmp.csv
    # Separate remaining columns with comma
    awk '{print $1 "," $2 "," $3 "," $4 "," $5 "," $8}' tmp.csv > "${line}"
    # Replace unwanted char to split two values
    cat "${line}" | tr ':' ',' > tmp.csv
    # Make an array of months to loop through
    monthArr=("Jan" "Feb" "Mar" "Apr" "May" "June" "July" "Aug" "Sep" "Oct" "Nov" "Dec")
    for val in "${!monthArr[@]}"
    do
        idx=$((val+1))
        # Replace each month string (Jan-Dec) with the month index value (1-12)
        sed -i 's/'"${monthArr[$val]}"'/'"${idx}"'/g' tmp.csv
    done
    # Add a desired meta-data header to the final file
    echo "start month,start day,start year,start time,ampm,label" > "${line}"
    # Append the processed text to the final file
    cat tmp.csv >> "${line}"
    rm tmp.csv
done < $input_file

rm files.txt

# Add a quick check to see that the processing worked
printf "\nResults: \n"
# Check what files are now in the directory
printf "\nls\n"
ls
# Check out how the first file in the directory turned out
files=$(ls)
echo $files | tr ' ' '\n' > files.txt
# Get the first file
f=$(head -n 1 files.txt)
printf "\nhead "${f}"\n"
# Display the first ten lines from it
head ${f}
rm files.txt



