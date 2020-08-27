#!/bin/bash

TTL=86400
FQDN=XXXXXXX
USER=XXXXXXX
PASSWD=XXXXXXX

usage() {
    echo "Usage: $0 <IP>"
}

if [ $# != 1 ]; then
    usage
    exit 1
fi

IP=$1
re='^(0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))\.){3}'
 re+='0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))$'

if [[ $IP =~ $re ]]; then
    curl -XPOST -H "Content-Type: application/json" -u $USER:$PASSWD "http://$FQDN/config/data/${BL}_indicators/append?h=${BL}&t=localdb" -d '{ "indicator": "'$IP'", "type": "IPv4", "ttl": 0 }'
    ufw show added | awk '/'$IP'/{ gsub("ufw","ufw delete",$0); system($0)}'
else
    usage
    exit 1
fi

exit 0
