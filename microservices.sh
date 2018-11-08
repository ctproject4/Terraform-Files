#!/bin/bash

CLUSTER_NAME=`grep cluster_Name properties | cut -d "=" -f2`

cd /home/ubuntu/
KUBECONFIG=$KUBECONFIG:~/.kube/config-$CLUSTER_NAME
export KUBECONFIG
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-$CLUSTER_NAME' >> ~/.bashrc
kubectl create -f microservices.yaml
