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

ROOT_DIR=$(git rev-parse --show-toplevel)
config_path=${ROOT_DIR}/pipelines/osspi-metric-store.yml

TEAM="${TEAM:-tobs-k8s-group}"
pipeline_name=${PIPELINE_NAME:-osspi-metric-store}
VERSION=${VERSION:-"1.6.0"}
OSM_ENVIRONMENT=${OSM_ENVIRONMENT:-"production"}

echo "using OSM_ENVIRONMENT: ${OSM_ENVIRONMENT}. Valid environments are beta and production"

fly --target runway set-pipeline \
    --pipeline ${pipeline_name} \
    --config ${config_path} \
    --var tile-version="${VERSION}" \
    --var osm-environment="${OSM_ENVIRONMENT}"

# fly --target runway login --concourse-url https://runway-ci.eng.vmware.com --team-name tobs-k8s-group
