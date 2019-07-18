#!/usr/bin/env bash

. ./metric-store-ci/tasks/shared_bash
set -eou pipefail

current_version=$(cat slack-rate-limit-version/version)
patch_version=$(patch_from_semver ${current_version})

if [ ${patch_version} -eq 1 ]; then
  echo 'Last run also passed, disable alert'
  alert_disable
else
  echo "Fixed after ${patch_version} attempt(s), send alert"
  alert_enable
fi
