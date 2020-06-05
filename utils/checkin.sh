#!/bin/bash

git config core.sshCommand "ssh -i /root/.ssh/id_rsa_example -F /dev/null"
git config --global user.name "tekton"
git config --global user.email tekton@us.ibm.com

git add . 
git commit -m "Enable CP4I ACE Server CI/CD"
git status
git push origin master

echo Check-in completed
