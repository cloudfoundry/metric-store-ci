FROM golang:latest as builder

COPY / /go/

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

RUN go build \
    -a \
    -installsuffix nocgo \
    -o /log-cache-nozzle \
    code.cloudfoundry.org/log-cache/cmd/nozzle

FROM alpine:latest

ENV LOGS_PROVIDER_ADDR="rlp:8082" \
    LOGS_PROVIDER_CA_FILE_PATH="/srv/certs/ca.crt" \
    LOGS_PROVIDER_CERT_FILE_PATH="/srv/certs/rlp.crt" \
    LOGS_PROVIDER_KEY_FILE_PATH="/srv/certs/rlp.key" \
    LOG_CACHE_ADDR="log-cache:8080" \
    CA_PATH="/srv/certs/ca.crt" \
    CERT_PATH="/srv/certs/log-cache.crt" \
    KEY_PATH="/srv/certs/log-cache.key" \
    ENV_DIR="/srv/conf.d"

COPY --from=builder /log-cache-nozzle /srv/
WORKDIR /srv
CMD [ "/bin/sh", "-c", "cat $ENV_DIR/* 2> /dev/null > /tmp/env; source /tmp/env; /srv/log-cache-nozzle" ]
