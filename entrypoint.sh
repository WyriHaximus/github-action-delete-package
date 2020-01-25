#!/bin/bash

set -eo pipefail

if [ $(echo ${INPUT_PACKAGEVERSIONID} | wc -c) -eq 1 ] ; then
  echo -e "\033[31mPackage version ID cannot be empty\033[0m"
  exit 1
fi

delete_package() {
#  echo -e "{\"query\": \"mutation { deletePackageVersion(input:{packageVersionId:\\\"$1\\\"}) { success }}\"}" >> /workdir/payload.json
  echo -e "$1"

#  while [ ! -f /workdir/payload.json ]
#  do
#    sleep 0.1
#  done
#
#  cat /workdir/payload.json
}

export -f delete_package

echo "${INPUT_PACKAGEVERSIONID}" | tr "," "\r\n" | xargs -I {} bash -c 'delete_package "$@"' _ {}


exit 3

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
