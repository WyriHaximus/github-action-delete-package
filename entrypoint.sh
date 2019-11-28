#!/bin/bash

set -eo pipefail

if [ $(echo ${INPUT_PACKAGEVERSIONID} | wc -c) -eq 1 ] ; then
  echo -e "\033[31mPackage version ID cannot be empty\033[0m"
  exit 1
fi

echo -e "{\"query\": \"mutation { deletePackageVersion(input:{packageVersionId:\\\"$INPUT_PACKAGEVERSIONID\\\"}) { success }}\"}" > /workdir/payload.json

sleep 3

cat /workdir/payload.json

curl --request PATCH \
  --url https://api.github.com/graphql \
  --header "Accept: application/vnd.github.package-deletes-preview+json" \
  --header "Authorization: Bearer ${GITHUB_TOKEN}" \
  --header 'Content-Type: application/json' \
  --data "$(cat /workdir/payload.json)" \
  -o /workdir/response.json \
  -s

sleep 3

cat /workdir/response.json
