#!/usr/bin/env bash

# From Stephen Donner Github

if [ $# -lt 1 ]; then
  echo 1>&2 "Usage: zap-docker.sh <target-url>"
  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "[ERROR]: too many arguments"
  exit 2
fi

ZAP_API_PORT=2375

# starting ZAP daemon listening on port 2375
CONTAINER_ID=$(docker run -u zap -p $ZAP_API_PORT:$ZAP_API_PORT -v $(pwd):/zap/working:rw -d owasp/zap2docker-weekly zap.sh -daemon -port $ZAP_API_PORT -host 127.0.0.1 -config api.disablekey=true -config scanner.attackOnStart=true -config view.mode=attack -config connection.dnsTtlSuccessfulQueries=-1 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true)

CONTAINER_IP_ADDR=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)

# the target URL for ZAP to scan
TARGET_URL=$1

# set up our status spinner
#spin='-\|/'
#i=0;

# Poll the api and wait for it to start up
#while ! docker exec $CONTAINER_ID zap-cli -p $ZAP_API_PORT status | grep running > /dev/null
#do
 #i=$(( (i+1) %4 ))
 #printf "\rWaiting for OWASP ZAP to start ${spin:$i:1}"
 #sleep .1
#done
#echo "\nZAP has successfully started"

# waiting for the daemon to be running
docker exec $CONTAINER_ID zap-cli -p $ZAP_API_PORT status -t 120

# accessing the target url
docker exec $CONTAINER_ID zap-cli -p $ZAP_API_PORT open-url $TARGET_URL

# launching the spider for crawling the target url
docker exec $CONTAINER_ID zap-cli -v -p $ZAP_API_PORT spider $TARGET_URL

# initiating the active scan recursively
docker exec $CONTAINER_ID zap-cli -v -p $ZAP_API_PORT active-scan -r $TARGET_URL

# showing the issues detected
docker exec $CONTAINER_ID zap-cli -p $ZAP_API_PORT alerts

# generating the report in HTML format
docker exec $CONTAINER_ID zap-cli -p $ZAP_API_PORT report -f html -o /zap/working/zap-report.html

# gathering container logs
docker logs $CONTAINER_ID >& zap.log
# cp $(docker inspect --format='{{.LogPath}}' $CONTAINER_ID) zap-log.json 

# stopping ZAP container
docker stop $CONTAINER_ID
