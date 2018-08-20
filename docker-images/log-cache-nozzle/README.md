
# Supported tags and respective `Dockerfile` links

- `latest` [(Dockerfile)][latest-dockerfile]

# Usage

- You must provide TLS certificates and keys for the log-cache-nozzle via a
  volume mount. These certs and keys are documented in the
  [Dockerfile][latest-dockerfile] and are used to talk to loggregator and
  log-cache.

You can generate the certificates and keys locally with the following command:

```bash
docker run --volume "$PWD/loggregator-certs:/output" loggregator/certs
```

For example:

```bash
docker run \
    --detach \
    --volume "$PWD/loggregator-certs:/srv/certs:ro" \
    loggregator/log-cache-nozzle
```

[latest-dockerfile]: https://github.com/cloudfoundry/loggregator-ci/blob/master/docker-images/log-cache-nozzle/Dockerfile
