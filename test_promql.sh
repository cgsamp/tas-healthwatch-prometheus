#!/bin/bash

#Prometheus VM IP
TSDB_IP=10.0.0.14

#Internal TAS components are secured with MTLS, so the certificate authority,
# certificate and key must be available and should be kept secure
TSDB_CA=/var/vcap/jobs/prometheus/config/certs/prometheus_ca.pem
TSDB_CERT=/var/vcap/jobs/prometheus/config/certs/prometheus_certificate.pem
TSDB_KEY=/var/vcap/jobs/prometheus/config/certs/prometheus_certificate.key

if test -z "$1"
then 
    PROMQL="up"
else
    PROMQL="$1"
fi

COMMAND=("\
curl -vk https://$TSDB_IP:9090/api/v1/query?query=$PROMQL \
--cacert $TSDB_CA \
--cert  $TSDB_CERT \
--key $TSDB_KEY
")

RESPONSE=$(eval "$COMMAND")

#If jq is not available on the system, delete "| jq ." and optionally pipe to file
echo $RESPONSE | jq .
