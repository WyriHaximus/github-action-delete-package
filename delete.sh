#!/bin/bash

set -eo pipefail

PACKAGE_VERSION_ID="$(</dev/stdin)"
echo -e "$PACKAGE_VERSION_ID\r\n"
#return
#exit 5
#
#if [ $(echo ${INPUT_PACKAGEVERSIONID} | wc -c) -eq 1 ] ; then
#  echo -e "\033[31mPackage version ID cannot be empty\033[0m"
#  exit 1
#fi
#
#echo "${INPUT_PACKAGEVERSIONID}" | cut -d","
#echo -e "{\"query\": \"mutation { deletePackageVersion(input:{packageVersionId:\\\"$INPUT_PACKAGEVERSIONID\\\"}) { success }}\"}" > /workdir/payload.json
#
#while [ ! -f /workdir/payload.json ]
#do
#  sleep 0.1
#done
#
#cat /workdir/payload.json
#
#exit 3

#curl --request POST \
#  --url https://api.github.com/graphql \
#  --header "Accept: application/vnd.github.package-deletes-preview+json" \
#  --header "Authorization: Bearer ${GITHUB_TOKEN}" \
#  --data "$(cat /workdir/payload.json)" \
#  -o /workdir/response.json \
#  -s
#
#while [ ! -f /workdir/response.json ]
#do
#  sleep 0.1
#done
#
#printf "::set-output name=success::%s" $(cat /workdir/response.json | jq '.data.deletePackageVersion.success')
