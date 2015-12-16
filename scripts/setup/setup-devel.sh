#!/bin/bash

pushd ~
mkdir -p logs
mkdir -p conf
popd

# Bootstrap
source ./scripts/setup-vars.sh
source ./scripts/setup-config.sh
source ./scripts/setup-apt.sh

# Setup and install services dependencies
source ./scripts/setup-postgresql.sh
source ./scripts/setup-redis.sh

# Setup and install python related dependencies
source ./scripts/setup-buildessential.sh
source ./scripts/setup-python.sh
source ./scripts/setup-java.sh

# Setup BestShift (to come)
#source ./scripts/setup-frontend.sh
#source ./scripts/setup-backend.sh

# Cleanup
source ./scripts/cleanup.sh