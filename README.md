# metric-store-ci

History located at github.com/cloudfoundry/log-cache-ci.
CI pipelines and tasks for developing and shipping github.com/cloudfoundry/metric-store-release

# To set pipeline

Log into concourse with
```fly --target runway login --concourse-url https://runway-ci-sfo.eng.vmware.com/ --team-name phoenix-metric-store```


Then run the following script from the project directory
``` ./scripts/set-pipeline <pipeline name>```
