#!/bin/bash

# Copyright (C) 2016-2019 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
INFO_COLOR="\033[34;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"

SCRIPT=$(readlink -f "$0")
# echo $SCRIPT
SCRIPTPATH=$(dirname "$SCRIPT")
# echo $SCRIPTPATH

. ${SCRIPTPATH}/local.sh

PROFILE=$1
driver=${2:-virtualbox}
KUBECONFIG_FILE=${3:-"./deploy/minikube/kube-config"}
memory=${4:-3072}

export KUBECONFIG=${KUBECONFIG_FILE}
minikube start --profile ${PROFILE} \
  --vm-driver=${driver} \
  --memory ${memory} \
  --logtostderr -v 0

# this for loop waits until kubectl can access the api server that Minikube has created
for i in {1..300}; do # timeout for 10 minutes
  kubectl get po &> /dev/null
  if [ $? -ne 1 ]; then
    echo "Kubernetes is ready"
    break
  fi
  echo "Wait for Kubernetes ..."
  sleep 2
done

echo -e "${OK_COLOR}Kubernetes configuration file: ${KUBECONFIG_FILE}${NO_COLOR}"
if [ ! -f ${KUBECONFIG} ]; then
  echo "Kubectl configuration file does not exist"
  exit 1
fi
cat ${KUBECONFIG_FILE}

echo -e "${OK_COLOR}Configure Minikube for Atmos${NO_COLOR}"
kubectl apply -f kubernetes/minikube/namespace.yaml
kubectl apply -f kubernetes/minikube/sa.yaml

echo -e "${OK_COLOR}Minikube enable addons:${NO_COLOR}"
minikube addons enable ingress --profile ${PROFILE}

echo -e "${OK_COLOR}Minikube status:${NO_COLOR}"
minikube status --profile ${PROFILE}

echo -e "${OK_COLOR}Kubernetes info:${NO_COLOR}"
kubectl cluster-info
