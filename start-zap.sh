#!/bin/bash

# starting owasp-zap daemon on port ZAP_PORT

if [ $# -lt 1 ]; then
  echo 1>&2 "Usage: start-zap.sh <port-number>"
  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "[ERROR]: too many arguments"
  exit 2
fi

ZAP_PORT=$1

/usr/share/owasp-zap/zap.sh -daemon -port $ZAP_PORT -host 0.0.0.0 -config api.disablekey=true -config scanner.attackOnStart=true -config view.mode=attack -config connection.dnsTtlSuccessfulQueries=-1 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true &>/dev/null &