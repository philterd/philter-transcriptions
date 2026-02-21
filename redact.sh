#!/bin/bash -e

# The scripts to transcribe audio using Amazon Transcribe is located under `./transcribe`.
# We are NOT actually going to call Amazon Transcribe here because availability of actual audio is zero.
# Instead, we are going to use a modified transcription and pipe it into Philter to be redacted.

TRANSCRIBED_TEXT=`cat transcribe/job-output.json |  jq -r .results.transcripts[].transcript`

# To get *just* the redacted text from Philter:
#curl "http://localhost:8080/api/filter?p=example_policy" \
#	-d "${TRANSCRIBED_TEXT}" \
#  -H "Content-type: text/plain"

# Use /api/explain to get more info on what happened.
curl -s "http://localhost:8080/api/explain?p=example_policy" \
	-d "${TRANSCRIBED_TEXT}" \
  -H "Content-type: text/plain" | jq
