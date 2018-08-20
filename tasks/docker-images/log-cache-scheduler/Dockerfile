FROM golang:latest as builder

COPY / /go/

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

RUN go build \
    -a \
    -installsuffix nocgo \
    -o /log-cache-scheduler \
    code.cloudfoundry.org/log-cache/cmd/scheduler

FROM alpine:latest

ENV NODE_ADDRS=log-cache:8080 \
    GROUP_READER_NODE_ADDRS=log-cache:8080 \
    CA_PATH="/srv/certs/ca.crt" \
    CERT_PATH="/srv/certs/log-cache.crt" \
    KEY_PATH="/srv/certs/log-cache.key" \
    ENV_DIR="/srv/conf.d"

COPY --from=builder /log-cache-scheduler /srv/
WORKDIR /srv
CMD [ "/bin/sh", "-c", "cat $ENV_DIR/* 2> /dev/null > /tmp/env; source /tmp/env; /srv/log-cache-scheduler" ]
