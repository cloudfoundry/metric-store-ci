#!/usr/bin/env bash
set -efuo pipefail

which fly || (
  echo "This requires fly to be installed"
  echo "Download the binary from https://github.com/concourse/concourse/releases or from the Runway Concourse: https://runway-ci.eng.vmware.com"
  exit 1
)

fly -t runway sync || (
  echo "This requires the runway target to be set"
  echo "Create this target by running 'fly -t runway login -c https://runway-ci.eng.vmware.com -n tobs-k8s-group'"
  exit 1
)

pipeline_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
OSM_ENVIRONMENT=${OSM_ENVIRONMENT:-"production"}
echo "using OSM_ENVIRONMENT: ${OSM_ENVIRONMENT}. Valid environments are beta and production"

fly --target runway-ci set-pipeline \
    --pipeline tile-scan-metric-store \
    --config "${pipeline_dir}/pipeline.yml" \
    --var gcp_service_account_key="$(op read "op://AOA-Legacy/cf-loggregator-gcp-service-account/notesPlain")" \
    --var osm-environment="${OSM_ENVIRONMENT}"
