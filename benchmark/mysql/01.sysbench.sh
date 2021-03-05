#!/bin/bash

HOST=192.168.14.173
PORT=3306
USERNAME=root
PASSWORD=ntels1234
DATABASE=test
CASE=oltp_insert
# oltp_insert
# oltp_read_write
# oltp_write_only

sysbench\
  --threads=16 \
  --tables=1 \
  --time=600 \
  --report-interval=10 \
  --mysql-db=$DATABASE \
  --mysql-user=$USERNAME \
  --mysql-password=$PASSWORD \
  --mysql-host=$HOST \
  --mysql-port=$PORT \
  --table_size=1024 \
  --auto_inc=on\
  --db-ps-mode=disable\
  --db-driver=mysql\
  $CASE "$@"
