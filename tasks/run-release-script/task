#!/bin/bash

set -ex

if [ "$SCRIPT" = "" ]; then
  echo SCRIPT environment variable required
  exit 1
fi

pushd release-repo
  export GOPATH="$PWD"
  export PATH="$GOPATH/bin:$PATH"
  $SCRIPT
popd

cp -r release-repo/. updated-release-repo/
