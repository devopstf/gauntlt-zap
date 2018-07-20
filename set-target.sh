#!/usr/bin/env bash

if [ $# -lt 1 ]; then
  echo 1>&2 "Usage: set-target.sh <target-url>"
  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "[ERROR]: too many arguments"
  exit 2
fi

echo "default: TARGET_HOSTNAME=$1" > ./config/cucumber.yml
