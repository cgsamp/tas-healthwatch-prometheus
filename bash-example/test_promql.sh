#!/bin/bash

#Prometheus VM IP
TSDB_IP=10.225.63.92

#Internal TAS components are secured with MTLS, so the certificate authority,
# certificate and key must be available and should be kept secure
TSDB_CA=secret/tsdb_ca.pem
TSDB_CERT=secret/tsdb_certificate.pem
TSDB_KEY=secret/tsdb_certificate.key

COMMAND=(
curl -k \
-G --data-urlencode query=$(cat query.promql) \
https://"$TSDB_IP":9090/api/v1/query \
--cacert "$TSDB_CA" \
--cert  "$TSDB_CERT" \
--key "$TSDB_KEY"
)

#echo "${COMMAND[@]}"

#Pipe the curl command's status output to null to keep the response clean
RESPONSE=$("${COMMAND[@]}" 2> /dev/null)

#If jq is not available on the system, delete "| jq ." and optionally pipe to file
echo $RESPONSE | jq .
