FROM alpine:3.11

RUN apk add --no-cache curl bash jq

RUN mkdir /workdir
COPY entrypoint.sh /workdir/entrypoint.sh
COPY delete.sh /workdir/delete.sh
WORKDIR /workdir

ENTRYPOINT ["/workdir/entrypoint.sh"]
