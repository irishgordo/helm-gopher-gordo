#! /usr/bin/bash
kubectl apply -f https://raw.githubusercontent.com/harvester/experimental-addons/main/rancher-vcluster/rancher-vcluster.yaml
sleep 5
kubectl apply -f harvester-vcluster-addon-needed-enablement.yaml