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

MINIKUBE_URI="https://storage.googleapis.com/minikube"
KUBE_URI="https://storage.googleapis.com/kubernetes-release"

if [ ! -x "$(command -v minikube)" ]; then
  echo "Download minikube"
  curl -Lo minikube ${MINIKUBE_URI}/releases/latest/minikube-linux-amd64 \
    && chmod +x minikube
  export PATH=${PATH}:.
fi

if [ ! -x "$(command -v kubectl)" ]; then
  echo "Download kubectl"
  curl -Lo kubectl ${KUBE_URI}/release/$(curl -s ${KUBE_URI}/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl
  export PATH=${PATH}:.
fi

export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export CHANGE_MINIKUBE_NONE_USER=true

export MINIKUBE_HOME=$HOME
