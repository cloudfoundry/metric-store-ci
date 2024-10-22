#!/usr/bin/env bash
set -efuo pipefail

which fly || (
  echo "This requires fly to be installed"
  echo "Download the binary from https://github.com/concourse/concourse/releases or from Concourse: https://tpe-concourse-rock.eng.vmware.com/"
  exit 1
)

fly -t tpe-observability sync || (
  echo "This requires the fly target to be set"
  echo "Create this target by running 'fly -t tpe-observability login -c https://tpe-concourse-rock.eng.vmware.com/ -n tas-legacy-observability'"
  exit 1
)

ROOT_DIR=$(git rev-parse --show-toplevel)
config_path=${ROOT_DIR}/pipelines/srp-pipeline.yml

TEAM="${TEAM:-tas-legacy-observability}"
pipeline_name=${PIPELINE_NAME:-srp-metric-store}
VERSION=${VERSION:-"1.7.0"}


fly --target tpe-observability set-pipeline \
    --pipeline ${pipeline_name} \
    --config ${config_path} \
    --var tile-version="${VERSION}"
# fly --target tpe-observability login --concourse-url https://tpe-concourse-rock.eng.vmware.com/ --team-name tas-legacy-observability
