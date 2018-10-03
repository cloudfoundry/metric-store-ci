#!/usr/bin/env bash

. ./log-cache-ci/tasks/shared_bash
set -eoux pipefail

current_version=$(cat slack-rate-limit-version/version)
patch_version=$(patch_from_semver ${current_version})
alert_multiple=${alert_multiple:-5}

if [[ ${patch_version} -gt 1 && $(( ${patch_version} % ${alert_multiple} )) -ne 0 ]]; then
  echo "Not the first failure or a multiple of ${alert_multiple}, disable alert (failure #${patch_version})"
  alert_disable
else
  echo "First failure or a multiple of ${alert_multiple}, enable alert (failure #${patch_version})"
  alert_enable
fi
