#!/usr/bin/env bash

set -eufo pipefail

if ! which op ; then
    echo '1Password CLI is required'
    exit 1
fi

op signin --account sunnylabsops.1password.com -f

bbl_dir=${1:-$HOME/workspace/denver-deployments/concourse}

pushd "${bbl_dir}"
    eval "$(bbl print-env)"
popd
credhub get --name /concourse/metric-store-log-cache/srp-helper-harbor-credentials

credhub set \
  --name /concourse/metric-store-log-cache/datadog_api_key \
  --type password \
  --password "$(op read "op://AOA-Legacy/datadog_api_key/notesPlain")"

credhub set \
  --name /concourse/metric-store-log-cache/svcboteos_github_private_key \
  --type password \
  --password "$(op read "op://AOA-Legacy/svcboteos github key/private key")"

credhub set \
  --name /concourse/metric-store-log-cache/svcboteos_github_access_token \
  --type password \
  --password "$(op read "op://AOA-Legacy/svcboteos github access token/notesPlain")"

credhub set \
  --name /concourse/metric-store-log-cache/denver_locks_deploy_key \
  --type password \
  --password "$(op read "op://AOA-Legacy/denver-locks-deploy-key/private key")"

credhub set \
  --name /concourse/metric-store-log-cache/metric_store_ci_deploy_key \
  --type password \
  --password "$(op read "op://AOA-Legacy/metric-store-ci-deploy-key/private key")"

srp_helper_credentials_json=$(op read "op://AOA-Legacy/srp_helper_credentials/notesPlain")

credhub set \
  --name /concourse/metric-store-log-cache/srp-helper-harbor-credentials \
  --type user \
  --username "$(echo "${srp_helper_credentials_json}" | gojq -r .client_id)" \
  --password "$(echo "${srp_helper_credentials_json}" | gojq -r .client_secret)"
credhub get --name /concourse/metric-store-log-cache/srp-helper-harbor-credentials
srp_client_credentials_json=$(op read "op://AOA-Legacy/srp_client_credentials/notesPlain")

credhub set \
  --name /concourse/metric-store-log-cache/srp-client-credentials \
  --type user \
  --username "$(echo "${srp_client_credentials_json}" | gojq -r .client_id)" \
  --password "$(echo "${srp_client_credentials_json}" | gojq -r .client_secret)"

credhub set \
  --name /concourse/metric-store-log-cache/pws_datadog_forwarder_client \
  --type user \
  --username "$(op read "op://AOA-Legacy/pws-datadog-forwarder-client/username")" \
  --password "$(op read "op://AOA-Legacy/pws-datadog-forwarder-client/password")"

credhub set \
  --name /concourse/metric-store-log-cache/gcp_service_account_key \
  --type password \
  --password "$(op read "op://AOA-Legacy/cf-loggregator-gcp-service-account/notesPlain")"

credhub set \
  --name /concourse/metric-store-log-cache/pivnet_token \
  --type password \
  --password "$(op read "op://AOA-Legacy/pivnet-token/notesPlain")"

credhub set \
  --name /concourse/metric-store-log-cache/slack_high_visibility_alert_webhook_url \
  --type value \
  --value "$(op read "op://AOA-Legacy/slack_high_visibility_alert_webhook_url/notesPlain")"

credhub set \
  --name /concourse/metric-store-log-cache/smith_token \
  --type password \
  --password "$(op read "op://AOA-Legacy/toolsmiths-api-token/notesPlain")"

credhub set \
  --name /concourse/metric-store-log-cache/tracker_token \
  --type password \
  --password "$(op read "op://AOA-Legacy/app-metrics-tracker-token/notesPlain")"

credhub set \
  --name /concourse/metric-store-log-cache/yuzu_datadog_forwarder_password \
  --type password \
  --password "$(op read "op://AOA-Legacy/yuzu-datadog-forwarder-client/password")"

credhub set \
  --name /concourse/metric-store-log-cache/cf_denver_service_account \
  --type password \
  --password "$(op read "op://AOA-Legacy/cf-denver service account/notesPlain")"
