#!/bin/bash

AWS_PROFILE="your_profile"
AWS_REGION="us-east-1"

aws transcribe start-medical-transcription-job \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} \
  --cli-input-json file://job.json

# Look at job-output.json for how the transcription job output is formatted.