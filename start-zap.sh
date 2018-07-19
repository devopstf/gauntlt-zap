#!/bin/bash

# Startin owasp-zap daemon on port 2375

/usr/share/owasp-zap/zap.sh -daemon -port 2375 -host 127.0.0.1 -config api.disablekey=true -config scanner.attackOnStart=true -config view.mode=attack -config connection.dnsTtlSuccessfulQueries=-1 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true &>/dev/null &