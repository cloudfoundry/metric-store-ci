#!/bin/bash
#
# _build_under_observer.sh
#
# This script is not meant to be invoked directly.  It is run to do a a local build under the SRP observer.
# The script assumes that it is invoked in an environment where all env variables and tools
# that are required are already installed.  The script does check to see if these values are set and issues
# errors if not.  There are two ways to invoke it:
#  1) run the build-using-docker.sh shell script, which sets various required variables and calls docker to do the build
#     in an isolated environment with the needed tools.
#  2) setup your local environment such that it has all necessary tools and variables set and then call build-local.sh

#get the directory of this script regardless of where it is invoked from
BRANCH_DIR="$( cd "$( dirname "$0" )" && pwd )"

if [ -z "${OUTPUT_VERSION}" ]; then
    echo "ERROR: env must define OUTPUT_VERSION to be the version string to publish to"
    exit 1
fi

if [ -z "${SRP_WORKING_DIR}" ]; then
   echo "ERROR: env must define SRP_WORKING_DIR to be the path to SRP working directory"
fi

######################################################################################
echo "starting observer"
# Start observer in deemon mode, dump the required environment variables to envs.sh
observer_agent -m start_observer --output_environment envs.sh --env_to_shell

# Set the required environment variables (so artifact download will use the observer proxies)
source ./envs.sh

###############################################################################
# ALL BUILDING AND PUBLISHING OF OUTPUTS GOES IN THIS BLOCK

echo "Running gradle build"
gradle --info test --no-daemon build -Pversion=${OUTPUT_VERSION}

# capture env used in the build
srp util env --saveto=${SRP_WORKING_DIR}/build-env.json

if [ "${ARTIFACTORY_AUTH_TOKEN}" != "" ]; then
    APP_JAR="srp-example-gradle-${OUTPUT_VERSION}-SNAPSHOT.jar"
    PUBLISH_URL="https://artifactory.eng.vmware.com/artifactory/srp-examples-generic-local/${BUILD_PROJECT}/${OUTPUT_VERSION}/${APP_JAR}"
    echo "Publishing build output to ${PUBLISH_URL}"
    curl -H "X-JFrog-Art-Api:${ARTIFACTORY_AUTH_TOKEN}" -T ./build/libs/${APP_JAR} ${PUBLISH_URL}
else
  echo "ARTIFACTORY_AUTH_TOKEN is not set, skipping publish to artifactory"
fi

###############################################################################
echo "stopping observer and cleaning up"
# Unset the environment variables
source ./envs.sh unset

# Stop observer, generate network provenance file
observer_agent -m stop_observer -f ${SRP_WORKING_DIR}/network_provenance.json
cat ${SRP_WORKING_DIR}/network_provenance.json

# Remove envs.sh
rm -f envs.sh

