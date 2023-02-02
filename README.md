# Query TAS Healthwatch V2 with PromQL

This project shows how to connect to the Prometheus underlying Tanzu Application Service's Healthwatch monitoring product.

https://docs.pivotal.io/healthwatch/2-2/architecture.html

This Guide has two phases:

1. Setup and credential acquisition
2. Executing PromSQL and reviewing results

## Setup and Credential Acquisition

This step uses the `om` command-line utility to access OpsMan and obtain:
- OpsMan Certificate Authority
- TSDB Client Certificate
- TSDB Client Private Key
- TSDB IP

1. Follow instructions [for the om utility](https://docs.pivotal.io/ops-manager/3-0/install/cli.html). This requires sufficient access OpsMan, such as admin. More details are [listed here](https://github.com/pivotal-cf/om/blob/main/docs/README.md#authentication).

2. Execute the following commands to get the relevant certificates and store them locally. Note the -k skip-ssl-valdation is used; alternately, download and appropriately trust the OpsMan certificate authority.
```
mkdir secret
om -k --env=$OM_ENV certificate-authority --cert-pem > secret/tsdb_ca.pem
om -k --env=$OM_ENV credentials -p p-healthwatch2 -c .tsdb.tsdb_client_mtls -f cert_pem > secret/tsdb_certificate.pem
om -k --env=$OM_ENV credentials -p p-healthwatch2 -c .tsdb.tsdb_client_mtls -f private_key_pem > secret/tsdb_certificate.key

```

### Obtain Healthwatch TSDB IP

(Looking for CLI solution.)

Log into OpsManager. Click on Healthwatch tile. Select Status. Note one of the IP addresses. Use it in the CURL statement.

## Executing PromQL

Now that the credentials are stored, the `curl` command can be used.

```
TSDB_IP=10.225.63.92
TSDB_CA=secret/tsdb_ca.pem
TSDB_CERT=secret/tsdb_certificate.pem
TSDB_KEY=secret/tsdb_certificate.key

PROMQL="up"

curl -vk https://"$TSDB_IP":9090/api/v1/query?query="$PROMQL" \
--cacert "$TSDB_CA" \
--cert  "$TSDB_CERT" \
--key "$TSDB_KEY"

```

There is a sample `test_promql.sh` in this repository that provides a working code example. Usage example: 

```
./test_promql.sh tas_sli_task_failures_total\&start=2023-02-01T20:10:30.781Z\&end=2023-02-02T20:11:00.781Z\&step=15s
```