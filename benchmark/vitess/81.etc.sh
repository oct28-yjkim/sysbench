#!/bin/bash 

cat << EOF | kubectl create -f -
apiVersion: v1
kind: Service
metadata:
  labels:
    planetscale.com/cluster: example
    planetscale.com/component: vtctld
  name: vtctld
  namespace: default
spec:
  ports:
  - name: web
    port: 15000
    protocol: TCP
    targetPort: web
  - name: grpc
    port: 15999
    protocol: TCP
    targetPort: grpc
  selector:
    planetscale.com/cluster: example
    planetscale.com/component: vtctld
  sessionAffinity: None
  type: LoadBalancer
---
apiVersion: v1
kind: Service
metadata:
  labels:
    planetscale.com/cluster: example
    planetscale.com/component: vtgate
  name: vtgate
  namespace: default
spec:
  ports:
  - name: web
    port: 15000
    protocol: TCP
    targetPort: web
  - name: grpc
    port: 15999
    protocol: TCP
    targetPort: grpc
  - name: mysql
    port: 3306
    protocol: TCP
    targetPort: mysql
  selector:
    planetscale.com/cluster: example
    planetscale.com/component: vtgate
  sessionAffinity: None
  type: LoadBalancer
EOF 
