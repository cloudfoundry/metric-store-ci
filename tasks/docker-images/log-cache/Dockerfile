FROM golang:latest as builder

COPY / /go/

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

RUN go build \
    -a \
    -installsuffix nocgo \
    -o /log-cache \
    code.cloudfoundry.org/log-cache/cmd/log-cache

FROM alpine:latest

ENV ADDR=:8080 \
    CA_PATH="/srv/certs/ca.crt" \
    CERT_PATH="/srv/certs/log-cache.crt" \
    KEY_PATH="/srv/certs/log-cache.key" \
    ENV_DIR="/srv/conf.d"

EXPOSE 8080

COPY --from=builder /log-cache /srv/
WORKDIR /srv
CMD [ "/bin/sh", "-c", "cat $ENV_DIR/* 2> /dev/null > /tmp/env; source /tmp/env; /srv/log-cache" ]
