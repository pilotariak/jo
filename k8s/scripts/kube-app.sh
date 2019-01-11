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

SCRIPT=$(readlink -f "$0")
# echo $SCRIPT
SCRIPTPATH=$(dirname "$SCRIPT")
# echo $SCRIPTPATH

. ${SCRIPTPATH}/kube-commons.sh

clusters="minikube, gce, eks, ..."
environments="local, test or prod"
actions="log, shell, exec"

cluster=""
env=""
action=""
service=""
cmd=""

pod=""

function usage {
    echo -e "${OK_COLOR}Usage${NO_COLOR} :\n\t$0 -c <cluster> -e <env> -a <action> -s <service> [ -x <command>]\n"
    echo -e "OPTIONS:"
    echo -e "   -h :  display help\n"
    echo -e "${INFO_COLOR}Clusters:${NO_COLOR} : ${clusters}"
    echo -e "${INFO_COLOR}Environments${NO_COLOR} : ${environments}"
    echo -e "${INFO_COLOR}Actions${NO_COLOR} : ${actions}"
}

function find_pod {
    local cluster=$1
    local environment=$2
    local name=$3
    kube_context ${cluster} ${environment}
    echo -e "${OK_COLOR}Find application pod: ${name}${NO_COLOR}"
    pod=$(kubectl get pods -l app=${name} -o 'jsonpath={.items[*].metadata.name}')
    if [ -z "${pod}" ]; then
        echo -e "${ERROR_COLOR}No pod found.${NO_COLOR}"
        exit 1
    fi
}

function kube_app_exec {
    local kubepod=$1
    local command=$2
    echo -e "${OK_COLOR}Execute command: ${command}${NO_COLOR}"
    kubectl exec ${kubepod} -it -- ${command}
}

function kube_app_log {
    local kubepod=$1
    echo -e "${OK_COLOR}Retrieve logs${NO_COLOR}"
    kubectl logs -f ${kubepod}
}


function kube_app_shell {
    local kubepod=$1
    echo -e "${OK_COLOR}Execute shell${NO_COLOR}"
    kubectl exec ${kubepod} -it -- /bin/bash
}


if [ $# -eq 0 ]; then
    usage
    exit 0
fi


while getopts c:e:a:s:x:h option; do
    case "${option}"
    in
        c) cluster=${OPTARG};;
        e) env=${OPTARG};;
        a) action=${OPTARG};;
        s) service=${OPTARG};;
        x) cmd=${OPTARG};;
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
check_argument "${service}" "Please specify service"

case ${action} in
    log)
        find_pod ${cluster} ${env} ${service}
        kube_app_log ${pod}
        ;;
    shell)
        find_pod ${cluster} ${env} ${service}
        kube_app_shell ${pod}
        ;;
    exec)
        find_pod ${cluster} ${env} ${service}
        kube_app_log ${pod} ${cmd}
        ;;
    *)
        echo -e "${ERROR_COLOR}Invalid action: ${action}${NO_COLOR}"
        usage
        exit 1
esac

