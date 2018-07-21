#!/usr/bin/env bash

if [ $# -lt 1 ]; then
  echo 1>&2 "Usage: zap-attack.sh <target-url>"
  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "[ERROR]: too many arguments"
  exit 2
fi

if ! echo $1 | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*"; then
  echo 1>&2 "Unexpected argument: no such URL"
  exit 2
fi

# starting the ZAP daemon
zap-cli start -o "-config api.disablekey=true -config scanner.attackOnStart=true -config view.mode=attack -config connection.dnsTtlSuccessfulQueries=-1 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true"

# the target URL for ZAP to scan
TARGET_URL=$1

zap-cli status -t 120 

zap-cli open-url $TARGET_URL

zap-cli spider $TARGET_URL

zap-cli active-scan -r $TARGET_URL

zap-cli alerts

zap-cli report -f html -o zap-report.html

zap-cli shutdown