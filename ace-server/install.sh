#!/bin/bash

RELEASE=ace-server-cp4iivt-dev
if [ ! -z "$ACE_PROJECT" ] & [ ! -z "$ENV" ] ; then
  RELEASE=ace-server-$ACE_PROJECT-$ENV; 
fi;

PRODUCTION_DEPLOY=false
if [ "$PRODUCTION" = "true" ];     then PRODUCTION_DEPLOY="true"; fi;

TLS_HOSTNAME=$(oc get routes -n kube-system | grep proxy | awk -F' ' '{print $2 }')

# In case of IBM Cloud use ibmc-file-gold for the file storage
FILE_STORAGE=nfs
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  FILE_STORAGE="ibmc-file-gold"; 
fi;
if [ ! -z "$STORAGE_FILE" ]; then 
  FILE_STORAGE=$STORAGE_FILE
fi;

# In case of production, it can be set to "3"
REPLICA_COUNT=1
if [ "$PRODUCTION" = "true" ]; then 
  REPLICA_COUNT="3"; 
fi;

IMAGE_REGISTRY=cp.icr.io
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/ace"; 
fi;

ACE_IMAGE=$IMAGE_REGISTRY/ibm-ace-server-prod:11.0.0.6.1
if [ ! -z "$IMAGE" ];  then 
  ACE_IMAGE=$IMAGE; 
fi;

TRACE_ENABLED=true

PULL_SECRET=$(oc get secrets -n ace | grep deployer-dockercfg |  awk -F' ' '{print $1 }')

sed "s/PULL_SECRET/$PULL_SECRET/g"              ./ibm-ace-server-icp4i-prod/values_template.yaml  > ./ibm-ace-server-icp4i-prod/values_revised_1.yaml
sed "s/PRODUCTION_DEPLOY/$PRODUCTION_DEPLOY/g"  ./ibm-ace-server-icp4i-prod/values_revised_1.yaml > ./ibm-ace-server-icp4i-prod/values_revised_2.yaml
sed "s+ACE_IMAGE+$ACE_IMAGE+g"                  ./ibm-ace-server-icp4i-prod/values_revised_2.yaml > ./ibm-ace-server-icp4i-prod/values_revised_3.yaml
sed "s+IMAGE_REGISTRY+$IMAGE_REGISTRY+g"        ./ibm-ace-server-icp4i-prod/values_revised_3.yaml > ./ibm-ace-server-icp4i-prod/values_revised_4.yaml
sed "s/REPLICA_COUNT/$REPLICA_COUNT/g"          ./ibm-ace-server-icp4i-prod/values_revised_4.yaml > ./ibm-ace-server-icp4i-prod/values_revised_5.yaml
sed "s/TRACE_ENABLED/$TRACE_ENABLED/g"          ./ibm-ace-server-icp4i-prod/values_revised_5.yaml > ./ibm-ace-server-icp4i-prod/values_revised_6.yaml
sed "s/FILE_STORAGE/$FILE_STORAGE/g"            ./ibm-ace-server-icp4i-prod/values_revised_6.yaml > ./ibm-ace-server-icp4i-prod/values.yaml 

rm ./ibm-ace-server-icp4i-prod/values_revised_1.yaml
rm ./ibm-ace-server-icp4i-prod/values_revised_2.yaml
rm ./ibm-ace-server-icp4i-prod/values_revised_3.yaml
rm ./ibm-ace-server-icp4i-prod/values_revised_4.yaml
rm ./ibm-ace-server-icp4i-prod/values_revised_5.yaml
rm ./ibm-ace-server-icp4i-prod/values_revised_6.yaml

if [ "FILE_STORAGE" = "nfs" ]; then 
  oc create -f pv.yaml; 
fi;

echo 
echo "Final values.yaml"
echo 

cat ./ibm-ace-server-icp4i-prod/values.yaml 

echo 
echo "Running Helm Install"
echo 

helm install --name $RELEASE --namespace ace  ibm-ace-server-icp4i-prod  --tls --debug
