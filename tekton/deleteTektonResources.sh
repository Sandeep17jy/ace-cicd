#!/bin/sh

oc project cp4i-ace-server 

oc delete -f ./manifests/ace-server-secrets.yaml

oc delete -f ./manifests/ace-server-resources.yaml

oc delete -f ./manifests/install-ace-server-task.yaml
oc delete -f ./manifests/uninstall-ace-server-task.yaml
oc delete -f ./manifests/build-bar-task.yaml
oc delete -f ./manifests/generate-bar-task.yaml

oc delete -f ./manifests/ace-server-deploy-pipeline.yaml
oc delete -f ./manifests/ace-server-uninstall-pipeline.yaml
oc delete -f ./manifests/generate-bar-pipeline.yaml
oc delete -f ./manifests/build-bar-pipeline.yaml
oc delete -f ./manifests/install-ace-server-pipeline.yaml
