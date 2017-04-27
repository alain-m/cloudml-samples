#!/bin/bash
# Copyright 2016 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This sample assumes you're already setup for using CloudML.  If this is your
# first time with the service, start here:
# https://cloud.google.com/ml/docs/how-tos/getting-set-up

# Now that we are set up, we can start processing some flowers images.

: "${MODEL_NAME?Need to set MODEL_NAME}"

declare -r PROJECT=$(gcloud config list project --format "value(core.project)")
declare -r JOB_ID="${MODEL_NAME}_deploy_$(date +%Y%m%d_%H%M%S)"  # Unlike the preprocessing jobs, this one needs to contain underscores instead of '-'
declare -r BUCKET="gs://${PROJECT}-${MODEL_NAME}"
declare -r GCS_PATH="${BUCKET}"
declare -r DICT_FILE="${BUCKET}/${MODEL_NAME}_datasets/dict.txt"

declare -r VERSION_NAME=v1

echo "******* DEPLOYMENT ******"

echo
echo "Using job id: " $JOB_ID
set -v -e

# Create a prediction API with the specified model name.
gcloud beta ml models create ${MODEL_NAME}

# Create and set a default version of the model with the specified version name.
gcloud beta ml versions create \
  --origin ${GCS_PATH}/training/model/ \
  --model ${MODEL_NAME} \
  ${VERSION_NAME}
gcloud beta ml versions set-default --model ${MODEL_NAME} ${VERSION_NAME}
