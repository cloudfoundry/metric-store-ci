#!/usr/bin/env bash
set -efuo pipefail

which fly || (
  echo "This requires fly to be installed"
  echo "Download the binary from https://github.com/concourse/concourse/releases or from Concourse: https://tpe-concourse-rock.eng.vmware.com/"
  exit 1
)

pipeline_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
OSM_ENVIRONMENT=${OSM_ENVIRONMENT:-"production"}
echo "using OSM_ENVIRONMENT: ${OSM_ENVIRONMENT}. Valid environments are beta and production"

fly --target tpe-observability set-pipeline \
    --pipeline tile-scan-metric-store \
    --config "${pipeline_dir}/pipeline.yml" \
    --var osm-environment="${OSM_ENVIRONMENT}"
