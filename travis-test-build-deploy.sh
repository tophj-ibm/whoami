#!/bin/bash
set -x

./travis-build.sh
./travis-test.sh
./travis-deploy.sh

