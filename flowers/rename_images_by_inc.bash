#!/bin/bash
# Rename image files in the specifed folder with incremental numbers

if [ $# -lt 2 ];then
  echo "Please provide a folder path + a prefix"
  exit 1
fi

folder=$1
prefix=$2

a=1
for i in $folder*.jpg; do
  new=$(printf "$folder$prefix%04d.jpg" "$a") #04 pad to length of 4
  mv -i -- "$i" "$new"
  let a=a+1
done
