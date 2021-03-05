#!/bin/bash

HOST=$(kubectl get svc vtgate -o json | jq -r ".status.loadBalancer.ingress[0].ip")
PORT=3306
USERNAME=user
DATABASE=sbtest
CASE=oltp_insert
# oltp_insert
# oltp_read_write
# oltp_write_only

sysbench\
  --threads=16 \
  --tables=2 \
  --time=1500 \
  --report-interval=10 \
  --mysql-db=$DATABASE \
  --mysql-user=$USERNAME \
  --mysql-host=$HOST \
  --mysql-port=$PORT \
  --table_size=1024 \
  --auto_inc=on \
  --db-ps-mode=disable\
  --db-driver=mysql\
  $CASE "$@"


# specfic count --events=N



