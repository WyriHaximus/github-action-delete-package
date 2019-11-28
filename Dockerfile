FROM alpine:3.10

RUN apk add --no-cache curl bash jq

RUN mkdir /workdir
COPY entrypoint.sh /workdir/entrypoint.sh
WORKDIR /workdir

ENTRYPOINT ["/workdir/entrypoint.sh"]
