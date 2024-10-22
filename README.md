# metric-store-ci

History located at github.com/cloudfoundry/log-cache-ci.
CI pipelines and tasks for developing and shipping github.com/cloudfoundry/metric-store-release

# To set pipeline

Log into concourse with
```fly --target tpe-observability login --concourse-url https://tpe-concourse-rock.acc.broadcom.net/ --team-name tas-legacy-observability```


Then run the following script from the project directory
``` ./scripts/set-pipeline <pipeline name>```
