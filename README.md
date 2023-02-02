# tas-healthwatch-prometheus

Sample code to connect to the Prometheus instance within TAS that supports Healthwatch2, and obtain some metrics.

Required:

- Network access to the TSDB TAS component (Prometheus instance)
- Access to the prometheus certificate authority, certificate, and private key
- Execute permissions for script, set with "chmod 755 test_promql.sh


Usage:
./test_promql.sh query

If no query is provided, "up" will be used as a test. Output is run through jq for happier formatting; delete jq if not available.
