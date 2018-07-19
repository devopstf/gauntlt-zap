#!/usr/bin/env bash

if [ $# -lt 1 ]; then
  echo 1>&2 "Usage: arachni-docker.sh <target-url>"
  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "[ERROR]: too many arguments"
  exit 2
fi

mkdir -p $PWD/reports $PWD/artifacts;

# assigning the URL we are going to run arachni against to
TARGET_URL=$1

# running all XSS checks against the TARGET URL
docker run \
    -v $PWD/reports:/arachni/reports ahannigan/docker-arachni \
    bin/arachni --output-verbose --scope-include-subdomains $TARGET_URL --checks=xss* --report-save-path=reports/arachni-report.afr;

# generating issues report in HTML format
docker run --name=arachni_report  \
    -v $PWD/reports:/arachni/reports ahannigan/docker-arachni \
    bin/arachni_reporter reports/arachni-report.afr --reporter=html:outfile=reports/arachni-report.html.zip;

# copying zipped report to artifacts folder
docker cp arachni_report:/arachni/reports/arachni-report.html.zip $PWD/artifacts;

# removing reporting container
docker rm arachni_report;