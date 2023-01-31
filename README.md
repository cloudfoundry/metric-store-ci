# metric-store-ci

History located at github.com/cloudfoundry/log-cache-ci.
CI pipelines and tasks for developing and shipping github.com/cloudfoundry/metric-store-release

# To set pipeline

Log into concourse with
```fly --target cf-denver login --concourse-url https://concourse.cf-denver.com/ --team-name metric-store-log-cache```

When updating credentials. Update the file in 1Password then run
``` ./scripts/populate_credhub.sh```

Then run the following script from the project directory
``` ./scripts/set-pipeline <pipeline name>```