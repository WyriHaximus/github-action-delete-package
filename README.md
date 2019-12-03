# Delete package from the Github Package Registry

Github Action that deletes the given package from the Github Package Registry.

## Options

This action supports the following options.

### packageVersionId

The version id of the package to be deleted, when null this action exits with a failure.

* *Required*: `Yes`
* *Type*: `string`

## Output

This action has only one output and that's the `success` output. This is the value we get back from the GraphQL API 
indicating whether the operation has been a success or failure. We'll leave it up to you to consider what that means 
for your workflow. 

## Example

The following example is a slimmed down version of my Docker Image clean up workflow. It runs hourly and takes at most 
10 seconds, including the building of this action. The workflow picks up one Docker Image and deletes that one, the next 
hour it will try to get another package id and delete it. When there isn't a Docker Image to delete it will silently 
skip the deletion and try again in an hour.

```yaml
name: Docker Image Cleanup
on:
  schedule:
    - cron:  '33 * * * *'
jobs:
  cleanup-one-old-or-with-the-wrong-name-tag:
    runs-on: ubuntu-latest
    steps:
      - name: Fetch releases
        run: |
          curl -X POST \
            -s \
            -H "Accept: application/vnd.github.package-deletes-preview+json" \
            -H "Authorization: bearer ${{ secrets.GITHUB_TOKEN }}" \
            -d '{"query":"query {repository(owner:\"${{ OWNER }}\", name:\"${{ REPOSITORY }}\") {registryPackages(last:1) {edges{node{id, name, versions(last:100){edges {node {id, updatedAt, version}}}}}}}}"}' \
            -o /tmp/response.json \
            --url https://api.github.com/graphql
      - name: Filter Releases
        run: "cat /tmp/response.json | jq -r 'def daysAgo(days): (now | floor) - (days * 86400); [.data.repository.registryPackages.edges[0].node.versions.edges | sort_by(.node.updatedAt|fromdate) | reverse | .[] | select( .node.version != \"docker-base-layer\" ) | .value[].node.id] | unique_by(.) | @csv'  | cut -d, -f1  | sed -e 's/^\"//' -e 's/\"$//' > /tmp/release.json"
      - name: Show Release
        id: release
        run: printf "::set-output name=id::%s" $(cat /tmp/release.json)
      - name: Delete Release
        uses: WyriHaximus/github-action-delete-package@master
        if: steps.release.outputs.id != ''
        with:
          packageVersionId: ${{ steps.release.outputs.id }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## License ##

Copyright 2019 [Cees-Jan Kiewiet](http://wyrihaximus.net/)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
