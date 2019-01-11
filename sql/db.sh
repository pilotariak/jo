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

migrations_path="migrations"


function usage {
    echo -e "${OK_COLOR}Usage${NO_COLOR} :\n\t$0 action\n"
    echo -e "OPTIONS:"
    echo -e "   -h :  display help\n"
    echo -e "${INFO_COLOR}Action: ${NO_COLOR} : version, up, down or drop"
}

function db_manage {
    local action=$1
    minikube_ip=$(minikube ip -p pilotariak)
    db_url="cockroachdb://trinquet:@${minikube_ip}:30257/pilotariak?query&sslmode=disable"
    echo ${db_url}
    ./migrate -verbose -database "${db_url}" -path "${migrations_path}" ${action}
}

if [ $# -eq 0 ]; then
    usage
    exit 0
fi

action=$1
case "${action}"
in
    version|up|down|drop)
        db_manage ${action}
        ;;
    "-h")
        usage
        exit 0
        ;;
    *)
        usage
        exit 1
        ;;
esac

