#!/usr/bin/env bash

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

SCRIPT=$(readlink -f "$0")
# echo $SCRIPT
SCRIPTPATH=$(dirname "$SCRIPT")
# echo $SCRIPTPATH

. ${SCRIPTPATH}/kube-commons.sh

clusters="minikube, gce , eks"
environments="local, test or prod"
all_services="cockroachdb"

K8S_SERVICES="services"

cluster=""
env=""
action=""
services=""

addons=""

function usage {
    echo -e "${OK_COLOR}Usage${NO_COLOR} :\n\t$0 -c <cluster> -e <env> -a <action> -s <service> [options]\n"
    echo -e "OPTIONS:"
    echo -e "   -h :  display help\n"
    echo -e "${INFO_COLOR}Clusters:${NO_COLOR} : ${clusters}"
    echo -e "${INFO_COLOR}Environments${NO_COLOR} : ${environments}"
    echo -e "${INFO_COLOR}Action${NO_COLOR} : create, destroy"
    echo -e "${INFO_COLOR}Services available${NO_COLOR} : ${all_services}"
}


function kube_directory {
    local action=$1
    local directory=$2
    if [ -d "${directory}" ]; then
        if [ -n "$(ls -A ${directory})" ]; then
            kubectl --kubeconfig=${kubeconfig} ${action} -f "${directory}" ${namespace}
        fi
    fi
}

function kube_files {
    local action=$1
    local directory=$2
    local environment=$3
    ls ${directory}/*-${environment}.yaml
    for file in $(ls ${directory}/*-${environment}.yaml 2>/dev/null); do
        kubectl --kubeconfig=${kubeconfig} ${action} -f "${file}" ${namespace}
    done
}

function kube_create {
    local cluster=$1
    local environment=$2
    local service=$3

    kube_context ${cluster} ${environment}
    echo -e "${INFO_COLOR}-> ${service}${NO_COLOR}"
    kube_directory "apply" "${K8S_SERVICES}/${service}/commons"
    kube_directory "apply" "${K8S_SERVICES}/${service}/${cluster}/commons"
    kube_files "apply" "${K8S_SERVICES}/${service}/${cluster}" ${environment}
}

function kube_destroy {
    local cluster=$1
    local environment=$2
    local service=$3

    kube_context ${cluster} ${environment}
    echo -e "${INFO_COLOR}-> ${service}${NO_COLOR}"
    kube_directory "delete" "${K8S_SERVICES}/${service}/commons"
    kube_directory "delete" "${K8S_SERVICES}/${service}/${cluster}/commons"
    kube_files "delete" "${K8S_SERVICES}/${service}/${cluster}" ${environment}
}

function kube_list {
    local cluster=$1
    local environment=$2
    kube_context ${cluster} ${environment}
    echo -e "${OK_COLOR}List resources into Kubernetes${NO_COLOR}"
    kubectl --kubeconfig=${kubeconfig} get all ${namespace}
}


if [ $# -eq 0 ]; then
    usage
    exit 0
fi

while getopts c:e:a:s:h option; do
    case "${option}"
    in
        c) cluster=${OPTARG};;
        e) env=${OPTARG};;
        a) action=${OPTARG};;
        s) services=${OPTARG};;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

check_argument "${cluster}" "Please specify cluster"
check_argument "${action}" "Please specify action"
check_argument "${env}" "Please specify environment"

if [ -z "${services}" ]; then
    # echo "Pas de service"
    services=${all_services}
fi

# Debug:
# echo "Cluster  : ${cluster}"
# echo "Action   : ${action}"
# echo "Env      : ${env}"
# echo "Services : ${services}"
# echo "URL      : ${url}"
# exit 0


case ${action} in
    list)
        kube_list ${cluster} ${env}
        ;;
    create)
        for service in ${services}; do
            kube_create ${cluster} ${env} ${service}
        done
        ;;
    destroy)
        for service in ${services}; do
            kube_destroy ${cluster} ${env} ${service}
        done
        ;;
    *)
        echo -e "${ERROR_COLOR}Invalid action: ${action}${NO_COLOR}"
        usage
        exit 1
esac
