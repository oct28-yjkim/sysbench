#!/bin/bash 

helm uninstall mysql 

kubectl delete pvc --all 
