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

APP = Trinquet / Kubernetes

PROFILE = pilotariak

KUBE_URI="https://storage.googleapis.com/kubernetes-release/release"
MINIKUBE_URI="https://storage.googleapis.com/minikube"

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-20s\033[0m

SHELL = /bin/bash

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) ====$(NO_COLOR)"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'

.PHONY: init-kube
init-kube:
	@echo -e "$(OK_COLOR)[$(APP)] Install Kubernetes tools$(NO_COLOR)"
	@curl -sLo minikube $(MINIKUBE_URI)/releases/latest/minikube-linux-amd64 \
    	&& chmod +x minikube
	curl -sLO $(KUBE_URI)/$$(curl -s ${KUBE_URI}/stable.txt)/bin/linux/amd64/kubectl \
		&& chmod +x kubectl

.PHONY: init
init: init-kube ## Initialize development environment

#
# Minikube
#

.PHONY: minikube-start
minikube-start: ## Start the minikube virtual machine
	@./scripts/minikube.sh $(PROFILE)
	KUBECONFIG=./minikube/kube-config kubectl create

PHONY: minikube-stop
minikube-stop: ## Stop the minikube virtual machine
	KUBECONFIG=./minikube/kube-config minikube stop --profile $(PROFILE)

.PHONY: minikube-status ## Check the Kubernetes cluster informations
minikube-status:
	KUBECONFIG=./minikube/kube-config minikube status --profile $(PROFILE)

.PHONY: minikube-ssh ## Log into Minikube machine
minikube-ssh:
	KUBECONFIG=./minikube/kube-config minikube ssh --profile $(PROFILE)

PHONY: minikube-dashboard
minikube-dashboard: ## Stop the minikube virtual machine
	KUBECONFIG=./minikube/kube-config minikube dashboard --profile $(PROFILE)

.PHONY: minikube-cluster ## Display Kubernetes cluster entities
minikube-cluster:
	KUBECONFIG=./minikube/kube-config kubectl get all --all-namespaces

