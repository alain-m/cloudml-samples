#!/bin/bash
# Creates dict.txt and *.csv files automatically by iterating through
# the folders of images in the dataset

if [ $# -lt 3 ];then
  echo "Syntax: $0 <model_name> <eval_sample_size_from_each_folder> <path_to_datasets_folder>"
  exit 1
fi

export MODEL_NAME=$1
export EVAL_SAMPLE_SIZE=$2  # this value can be adjusted depending on the size of your dataset
cd $3

while true; do
    read -p "This command will erase your existing dict.txt and *.csv files. Continue?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 1;;
        * ) echo "Please answer yes or no.";;
    esac
done

rm dict.txt
rm all_data.csv
rm eval_set.csv
rm train_set.csv

for d in */ ; do
  label=`basename "$d"`;
  echo -e "$label" >> dict.txt
  n=0; 
  for file in $label/*; 
  do
    echo -e "gs://savioke-research-${MODEL_NAME}/${MODEL_NAME}_datasets/"$file",$label" >> all_data.csv;
    if [[ $n -lt $EVAL_SAMPLE_SIZE ]]; then
      echo -e "gs://savioke-research-${MODEL_NAME}/${MODEL_NAME}_datasets/"$file",$label" >> eval_set.csv;
    else
      echo -e "gs://savioke-research-${MODEL_NAME}/${MODEL_NAME}_datasets/"$file",$label" >> train_set.csv;
    fi
    n=$(($n+1));
  done; 
done
