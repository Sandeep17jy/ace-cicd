#!/usr/bin/env bash

oc new-project cp4i-ace-server

. ./initConfig.sh

BASE64_COMMON_SERVICES_USERNAME=`echo -n $COMMON_SERVICES_USERNAME | base64`
BASE64_COMMON_SERVICES_PASSWORD=`echo -n $COMMON_SERVICES_PASSWORD | base64`
BASE64_COMMON_SERVICE_ENDPOINT=`echo -n $COMMON_SERVICE_ENDPOINT | base64`
BASE64_CLOUD_TYPE=`echo -n $CLOUD_TYPE | base64`
BASE64_OFFLINE_INSTALL=`echo -n $OFFLINE_INSTALL | base64`
BASE64_FILE_STORAGE=`echo -n $FILE_STORAGE | base64`
BASE64_GIT_API_KEY_OR_PASSWORD=`echo -n $GIT_API_KEY_OR_PASSWORD | base64`
BASE64_GIT_USER_NAME=`echo -n $GIT_USER_NAME | base64`

sed "s/BASE64_COMMON_SERVICES_USERNAME/$BASE64_COMMON_SERVICES_USERNAME/g"   ./manifests/ace-server-secrets-template.yaml   > ./manifests/ace-server-secrets-revised-1.yaml
sed "s/BASE64_COMMON_SERVICES_PASSWORD/$BASE64_COMMON_SERVICES_PASSWORD/g"   ./manifests/ace-server-secrets-revised-1.yaml  > ./manifests/ace-server-secrets-revised-2.yaml
sed "s/BASE64_COMMON_SERVICE_ENDPOINT/$BASE64_COMMON_SERVICE_ENDPOINT/g"     ./manifests/ace-server-secrets-revised-2.yaml  > ./manifests/ace-server-secrets-revised-3.yaml
sed "s/BASE64_CLOUD_TYPE/$BASE64_CLOUD_TYPE/g"                               ./manifests/ace-server-secrets-revised-3.yaml  > ./manifests/ace-server-secrets-revised-4.yaml
sed "s/BASE64_OFFLINE_INSTALL/$BASE64_OFFLINE_INSTALL/g"                     ./manifests/ace-server-secrets-revised-4.yaml  > ./manifests/ace-server-secrets-revised-5.yaml
sed "s/BASE64_FILE_STORAGE/$BASE64_FILE_STORAGE/g"                           ./manifests/ace-server-secrets-revised-5.yaml  > ./manifests/ace-server-secrets-revised-6.yaml
sed "s/BASE64_GIT_API_KEY_OR_PASSWORD/$BASE64_GIT_API_KEY_OR_PASSWORD/g"     ./manifests/ace-server-secrets-revised-6.yaml  > ./manifests/ace-server-secrets-revised-7.yaml
sed "s/BASE64_GIT_USER_NAME/$BASE64_GIT_USER_NAME/g"                         ./manifests/ace-server-secrets-revised-7.yaml  > ./manifests/ace-server-secrets-revised-8.yaml
sed "s/OPENSHIFT_CLUSTER_USERNAME/$OPENSHIFT_CLUSTER_USERNAME/g"             ./manifests/ace-server-secrets-revised-8.yaml  > ./manifests/ace-server-secrets-revised-9.yaml
sed "s/OPENSHIFT_CLUSTER_PASSWORD/$OPENSHIFT_CLUSTER_PASSWORD/g"             ./manifests/ace-server-secrets-revised-9.yaml  > ./manifests/ace-server-secrets.yaml

rm ./manifests/ace-server-secrets-revised-1.yaml 
rm ./manifests/ace-server-secrets-revised-2.yaml 
rm ./manifests/ace-server-secrets-revised-3.yaml 
rm ./manifests/ace-server-secrets-revised-4.yaml 
rm ./manifests/ace-server-secrets-revised-5.yaml 
rm ./manifests/ace-server-secrets-revised-6.yaml 
rm ./manifests/ace-server-secrets-revised-7.yaml 
rm ./manifests/ace-server-secrets-revised-8.yaml 
rm ./manifests/ace-server-secrets-revised-9.yaml 

oc create -f ./manifests/ace-server-secrets.yaml

oc create -f ./manifests/ace-server-resources.yaml

oc create -f ./manifests/install-ace-server-task.yaml
oc create -f ./manifests/uninstall-ace-server-task.yaml
oc create -f ./manifests/build-bar-task.yaml
oc create -f ./manifests/generate-bar-task.yaml

oc create -f ./manifests/ace-server-deploy-pipeline.yaml
oc create -f ./manifests/ace-server-uninstall-pipeline.yaml
oc create -f ./manifests/generate-bar-pipeline.yaml
oc create -f ./manifests/build-bar-pipeline.yaml
oc create -f ./manifests/install-ace-server-pipeline.yaml
