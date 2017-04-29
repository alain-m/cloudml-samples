#!/bin/bash
# Create json request file with all the images
# in the eval_set.csv

if [ $# -lt 1 ];then
  echo "Syntax: $0 <path_to_gcloud_folder_containing_eval_set_csv"
  echo "Ex: $0 gs://<bucket_name>/YYYY_datasets"
  exit 1
fi

folder_path=$1
i=0
rm request.json
mkdir tmp/
for o in `gsutil cat $folder_path/eval_set.csv | cut -d, -f1`;
do
	gsutil cp $o tmp/
	python -c 'import base64, sys, json; \
	img = base64.b64encode(open(sys.argv[1], "rb").read()); \
  	print json.dumps({"key":"'$i'", "image_bytes": {"b64": img}})' \
  	tmp/`basename $o` >> request.json
	i=$(($i+1))
done
rm -rf tmp/
