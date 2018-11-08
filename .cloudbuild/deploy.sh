#!/bin/bash

# Making the script to stop on any error (even within pipes)
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -eEo pipefail

BRANCH_NAME=$1
COMMIT_SHA=$2
REPO_NAME=$3
GOOGLE_CLOUD_PROJECT=$4
ENTRY_POINT=${5:-fn}

fail() {
  LINE=${1:-??}
  echo "[FAILED] Line: ${LINE} Deployment failed!"
  exit 1
}

trap 'fail $LINENO' ERR

echo "[INFO] Deployment began"

if [ -z $BRANCH_NAME ] || [ -z $COMMIT_SHA ] || [ -z $REPO_NAME ] || [ -z $GOOGLE_CLOUD_PROJECT ]; then
  echo "[FAILED] Missing parameters $0 BRANCH_NAME COMMIT_SHA REPO_NAME GOOGLE_CLOUD_PROJECT [ENTRY_POINT]"
  fail $LINENO
fi

if [ "master" = "$BRANCH_NAME" ]; then
  ENVIRONMENT=production
else
  ENVIRONMENT=staging
fi

DEPLOYMENT_NAME=${REPO_NAME}-${ENVIRONMENT}

echo "[INFO] Deploying ${DEPLOYMENT_NAME} @ ${GOOGLE_CLOUD_PROJECT}"

gcloud beta functions \
  deploy ${DEPLOYMENT_NAME} \
  --project ${GOOGLE_CLOUD_PROJECT} \
  --trigger-http \
  --entry-point ${ENTRY_POINT} \
  --runtime nodejs8

echo "[INFO] Deployment was successful"
