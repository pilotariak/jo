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

APP = Trinquet / SQL

PROFILE = pilotariak

DOCKER_SCHEMACRAWLER="schemacrawler/schemacrawler:v15.03.04"

MIGRATE_URI="https://github.com/golang-migrate/migrate/releases/download/"
MIGRATE_RELEASE="4.2.1"
MIGRATE = ./migrate
MIGRATION_PATH = ./migrations

COCKROACHDB_VERSION=2.1.3

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-20s\033[0m

# MINIKUBE_IP = $(shell minikube ip -p $(PROFILE))
# COCKROACHDB_URL = postgresql://trinquet@${MINIKUBE_IP}:30257/pilotariak?sslmode=disable

SHELL = /bin/bash

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) ====$(NO_COLOR)"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'

init-migrate:
	@echo -e "$(OK_COLOR)[$(APP)] Install SQL tools$(NO_COLOR)"
	@wget $(MIGRATE_URI)/v$(MIGRATE_RELEASE)/migrate.linux-amd64.tar.gz \
		&& tar zxvf migrate.linux-amd64.tar.gz \
	 	&& mv ./migrate.linux-amd64 ./migrate \
	 	&& chmod +x ./migrate \
	 	&& rm migrate.linux-amd64.tar.gz

init-cockroach:
	@echo -e "$(OK_COLOR)[$(APP)] Install CockroachDB CLI$(NO_COLOR)"
	wget -qO- https://binaries.cockroachdb.com/cockroach-v$(COCKROACHDB_VERSION).linux-amd64.tgz | tar  xvz \
		&& mv cockroach-v$(COCKROACHDB_VERSION).linux-amd64/cockroach . \
		&& rm -fr cockroach-v$(COCKROACHDB_VERSION).linux-amd64

init-schemacrawler:
	@echo -e "$(OK_COLOR)[$(APP)] Docker pull Schemacrawler image$(NO_COLOR)"
	@docker pull $(DOCKER_SCHEMACRAWLER)

.PHONY: init
init: init-migrate init-schemacrawler init-cockroach ## Initialize development environment

#
# Database
#

generate-sql-schema:
	@echo -e "$(OK_COLOR)[$(APP)] SQL schema $(output) with $(MINIKUBE_IP)$(NO_COLOR)"
	docker run --rm -v $$(pwd):/share $(DOCKER_SCHEMACRAWLER) \
		/opt/schemacrawler/schemacrawler.sh \
		-server=postgresql -host=$$(minikube ip -p $(PROFILE)) -port=30257 \
		-database=pilotariak -user=trinquet \
		-schemas=public -tables=.*\.* \
		-infolevel=standard -loglevel=CONFIG -command=schema -portablenames \
		-outputformat=$(output) -outputfile=/share/trinquet_sql.$(output) \
		-title="Pilotariak database"

.PHONY: sql-schema
sql-schema: ## Generate MariaDB database schema
	@make generate-sql-schema output=png && \
		make generate-sql-schema output=pdf && \
		make generate-sql-schema output=svg

# guard-%:
# 	@if [ "${${*}}" = "" ]; then \
# 	echo -e "$(ERROR_COLOR)Environment variable $* not set$(NO_COLOR)"; \
# 		exit 1; \
#     fi

db-env:
	MINIKUBE_IP$$(minikube ip -p $(PROFILE))

.PHONY: sql-version
sql-version: ## Display database version
	@echo -e "$(OK_COLOR)[$(APP)] CockroachDB migration UP$(NO_COLOR)"
	@./db.sh version

.PHONY: sql-up
sql-up: ## Apply all up migrations
	@echo -e "$(OK_COLOR)[$(APP)] CockroachDB migration UP$(NO_COLOR)"
	@./db.sh up

.PHONY: sql-down
sql-down: ## Apply all down migrations
	@echo -e "$(OK_COLOR)[$(APP)] CockroachDB migration DOWN$(NO_COLOR)"
	@db.sh down

.PHONY: sql-drop
sql-drop: ## Drop everyting inside database
	@echo -e "$(OK_COLOR)[$(APP)] CockroachDB migration DROP$(NO_COLOR)"
	@db.sh drop