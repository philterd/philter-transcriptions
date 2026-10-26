#!/bin/bash -e

# The scripts to transcribe audio using Amazon Transcribe is located under `./transcribe`.
# We are NOT actually going to call Amazon Transcribe here because availability of actual audio is zero.
# Instead, we are going to use a modified transcription and pipe it into Philter to be redacted.

source .env
PHILTER="https://localhost:8080"

# Philter serves HTTPS with a self-signed certificate, hence -k.
# Load the policy the first time; 409 means Philter already has it.
status=$(curl -sk -o /dev/null -w '%{http_code}' -X POST "${PHILTER}/api/policies?name=example_policy" \
  -H "Authorization: Bearer ${PHILTER_BOOTSTRAP_API_KEY}" \
  -H "Content-Type: application/json" \
  --data @policies/example_policy.json)
if [ "${status}" != "201" ] && [ "${status}" != "409" ]; then
  echo "Loading the policy failed with HTTP ${status}." >&2
  exit 1
fi

TRANSCRIBED_TEXT=`cat transcribe/job-output.json |  jq -r .results.transcripts[].transcript`

# To get *just* the redacted text from Philter:
#curl -sk "${PHILTER}/api/filter?p=example_policy" \
#  -H "Authorization: Bearer ${PHILTER_BOOTSTRAP_API_KEY}" \
#  -H "Content-Type: text/plain" \
#  --data-binary "${TRANSCRIBED_TEXT}"

# Use /api/explain to get more info on what happened.
curl -sk "${PHILTER}/api/explain?p=example_policy" \
  -H "Authorization: Bearer ${PHILTER_BOOTSTRAP_API_KEY}" \
  -H "Content-Type: text/plain" \
  --data-binary "${TRANSCRIBED_TEXT}" | jq
