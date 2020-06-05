#!/bin/bash

RELEASE=ace-server-cp4iivt-dev
if [ ! -z "$ACE_PROJECT" ] & [ ! -z "$ENV" ] ; then
  RELEASE=ace-server-$ACE_PROJECT-$ENV; 
fi;

helm delete $RELEASE --purge --tls

# In case of IBM Cloud use ibmc-file-gold for the file storage
FILE_STORAGE=nfs
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  FILE_STORAGE="ibmc-file-gold"; 
fi;
if [ ! -z "$STORAGE_FILE" ]; then 
  FILE_STORAGE=$STORAGE_FILE
fi;
if [ "FILE_STORAGE" = "nfs" ]; then 
  oc delete -f pv.yaml; 
fi;

echo "Uninstall of Ace Server is now complete"
echo
