#!/bin/bash
# Create json request file with all the images
# in the eval_set.csv

i=0
rm request.json
mkdir tmp/
for o in `gsutil cat gs://savioke-research-dock/dock_datasets/eval_set.csv | cut -d, -f1`;
do
	gsutil cp $o tmp/
	python -c 'import base64, sys, json; \
	img = base64.b64encode(open(sys.argv[1], "rb").read()); \
  	print json.dumps({"key":"$i", "image_bytes": {"b64": img}})' \
  	tmp/`basename $o` >> request.json
	i=$(($i+1))
done
rm -rf tmp/
