
# Supported tags and respective `Dockerfile` links

- `latest` [(Dockerfile)][latest-dockerfile]

# Usage

- You must provide TLS certificates and keys for the log-cache via a volume
  mount.

For example:

```bash
docker run \
    --detach \
    --publish 8080:8080 \
    --volume "$PWD/loggregator-certs:/srv/certs:ro" \
    loggregator/log-cache
```

[latest-dockerfile]: https://github.com/cloudfoundry/loggregator-ci/blob/master/docker-images/log-cache/Dockerfile
