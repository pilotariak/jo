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

set -e
set -u
# DEBUG:
# set -x

SCRIPT=$(readlink -f "$0")
# echo $SCRIPT
SCRIPTPATH=$(dirname "$SCRIPT")
# echo $SCRIPTPATH

. ${SCRIPTPATH}/commons.sh


CLUSTER_CONFIG="${KUBECONFIG:-${HOME}/.kube/config}"
MINIKUBE_CONFIG="${SCRIPTPATH}/../minikube/kube-config"
kubeconfig=""
namespace=""


function kube_context {
    local cluster=$1
    local environment=$2
    echo  -e "${OK_COLOR}Cluster: ${cluster}"
    echo  -e "${OK_COLOR}Environment: ${environment}"
    if [ "local" = "${environment}" ]; then
        local context="pilotariak"
        namespace="--namespace pilotariak-dev"
    else
        local context="${cluster}-pilotariak-${environment}"
    fi
    kube_config ${env}
    echo -e "${OK_COLOR}Switch to Kubernetes context: ${context} ${namespace}${NO_COLOR}" >&2
    kubectl --kubeconfig=${kubeconfig} config use-context ${context} >&2 || exit 1
}


function kube_config {
    local environment=$1
    case ${environment} in
        local)
            kubeconfig=${MINIKUBE_CONFIG}
            ;;
        test|prod)
            kubeconfig=${CLUSTER_CONFIG}
            ;;
        *)
            echo -e "${ERROR_COLOR}Invalid environment: ${environment}${NO_COLOR}"
            exit 1
    esac
}
