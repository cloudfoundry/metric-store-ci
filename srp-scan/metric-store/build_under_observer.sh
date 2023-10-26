#!/bin/bash
# Copyright (c) 2016-2023 VMware, Inc. All Rights Reserved.

######################################################################################
echo "starting observer"
# Start observer in deemon mode, dump the required environment variables to envs.sh
observer_agent -m start_observer --output_environment envs.sh --env_to_shell

# Set the required environment variables (so artifact download will use the observer proxies)
source ./envs.sh

###############################################################################
# ALL BUILDING AND PUBLISHING OF OUTPUTS GOES IN THIS BLOCK

# golang specific environment setup.  If you are using another tool, you should use
# tool specific setup to restrict to only consume dependencies from approved repositories

export CGO_ENABLED=0
export GOPRIVATE="gitlab.eng.vmware.com/*"
export GOPROXY="https://build-artifactory.eng.vmware.com/artifactory/proxy-golang-remote"
export GOSUMDB="https://build-artifactory.eng.vmware.com/artifactory/go-gosumdb-remote"
export GOROOT=$(go env GOROOT)
echo $GOROOT
mkdir -p ${SRP_WORKING_DIR}

echo "Running go build for linux/amd64"
cd metric-store-develop/src
echo "Running go build for linux/amd64"
GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o app-linux-amd64-metric-store cmd/metric-store/main.go

echo "Extracting incorporated dependencies from the output using go version"
go version -m app-linux-amd64-metric-store > ${SRP_WORKING_DIR}/go-app-deps.txt

# capture env used in the build
srp util env --saveto=${SRP_WORKING_DIR}/build-env.json

if [ "${ARTIFACTORY_AUTH_TOKEN}" != "" ]; then
 PUBLISH_URL="https://artifactory.eng.vmware.com/artifactory/srp-metric-store-release-go-local/${BUILD_PROJECT}/${OUTPUT_VERSION}/app-linux-amd64-metric-store"
 echo "=====> Publishing build output to ${PUBLISH_URL}"
 curl -H "X-JFrog-Art-Api:${ARTIFACTORY_AUTH_TOKEN}" -T app-linux-amd64-metric-store ${PUBLISH_URL}
 else
 echo "ARTIFACTORY_AUTH_TOKEN is not set, skipping publish to artifactory"
fi

echo "stopping observer and cleaning up"

observer_agent -m stop_observer -f ${SRP_WORKING_DIR}/network_provenance.json
cat ${SRP_WORKING_DIR}/network_provenance.json
source ./envs.sh unset
rm -f envs.sh
