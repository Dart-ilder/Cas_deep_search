#!/bin/bash

# Script splits download into chunks for ~10x faster download

# Usage:
# bash .\script.sh assessions.txt NUMBER_OF_PARTS (recommended are ~10)

# Needs packages:
# conda install -c conda-forge ncbi-datasets-cli
# conda install unzip

# ERRORS:
# Sometimes one part can fail due to networking error. Redownload through command:
# datasets download genome accession --inputfile "input_part_file" --filename "output_file"

# Better way to this would be by parrallckhbvihfizing downloads and unzip, but that's beyond my capabilities.

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <filename> <num_files>"
  exit 1
fi

filename="$1"

num_files="$2"

total_lines=$(wc -l < "$filename")
lines_per_file=$((total_lines / num_files))

split --lines="$lines_per_file" "$filename" "$filename.part" -a 2 -d
filename="${filename::-4}"
for i in $(seq -f "%02g" 0 "$num_files"); do
  input_file="$filename.txt.part$i"
  mv "${input_file}" "${input_file}.txt"
  input_file="${input_file}.txt"
  output_file="${filename}_part$i.zip"
  
  #datasets download genome accession --inputfile "$input_file" --filename "$output_file"
  #unzip -aou "${output_file}" -d "ncbi_dataset"   
  
  
  
  
done

i=11
input_file="$filename.txt.part$i"
mv "${input_file}" "${input_file}.txt"
input_file="${input_file}.txt"
output_file="${filename}_part$i.zip"
datasets download genome accession --inputfile "$input_file" --filename "$output_file"
unzip -aou "${output_file}" -d "ncbi_dataset"
