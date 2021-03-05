#!/bin/bash 

helm install mysql bitnami/mariadb -f values.yaml

# helm install mysql bitnami/mysql --set image.tag=5.7.33 --set global.storageClass=openebs-hostpath --set auth.rootPassword=ntels1234


