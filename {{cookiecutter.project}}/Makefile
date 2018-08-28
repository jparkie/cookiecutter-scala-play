SHELL := /bin/bash

TEST_ONLY = **

DOCKER_BASE = docker run \
	--volume $$(pwd):/repository \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	--volume $(HOME)/.sbt:/root/.sbt \
	--volume $(HOME)/.ivy2:/root/.ivy2 \
	--net host

DOCKER_RUN = $(DOCKER_BASE) \
	sbt_environment_12 sbt

DOCKER_INTERACTIVE = $(DOCKER_BASE) \
	--interactive \
	--tty \
	--entrypoint sbt \
	sbt_environment_12

SBT_RUN_PREREQUISITES ?= .docker/sbt_environment_12
SBT_RUN ?= $(DOCKER_RUN)

.docker/sbt_environment_12: Dockerfile
	docker build --tag sbt_environment_12 --file Dockerfile .
	mkdir -p .docker
	touch .docker/sbt_environment_12

help:
	@echo "Welcome to {{cookiecutter.project}}!"
	@echo ""
	@echo "This project is preferably managed with Docker. Please have Docker installed."
	@echo ""
	@echo "Please source project/use-local-sbt.sh if you want the Makefile to use the local sbt"
	@echo "Please source project/use-docker-sbt.sh if you want the Makefile to use the Docker sbt"
	@echo ""
	@echo "    uninstall-docker"
	@echo "        Remove Docker image sbt_environment_12"
	@echo "    sbt"
	@echo "        Start an interactive, Dockerized sbt shell"
	@echo "    clean"
	@echo "        Clean the Scala project"
	@echo "    compile"
	@echo "        Compile the Scala project"
	@echo "    coverage-report"
	@echo "        Generate test coverage reports"
	@echo "        See https://github.com/scoverage/sbt-scoverage for more information"
	@echo "    dependency-tree"
	@echo "        Generate an ASCII tree of the Scala project's dependencies"
	@echo "        See https://github.com/jrudolph/sbt-dependency-graph for more information"
	@echo "    docker-stage"
	@echo "        Generate a directory with the Dockerfile and environment prepared for creating a Docker image"
	@echo "        See https://sbt-native-packager.readthedocs.io/en/v1.3.7/formats/docker.html#tasks for more information"
	@echo "    docker-publish-local"
	@echo "        Build an image using the local Docker server"
	@echo "        See https://sbt-native-packager.readthedocs.io/en/v1.3.7/formats/docker.html#tasks for more information"
	@echo "    format"
	@echo "        Format the Scala project's code"
	@echo "        See https://scalameta.org/scalafmt/ for more information"
	@echo "    lint"
	@echo "        Lint the Scala project's code"
	@echo "        See http://www.scalastyle.org/sbt.html for more information"
	@echo "    release"
	@echo "        Verify the Scala project to version and release the code to git"
	@echo "        See https://github.com/sbt/sbt-release for more information"
	@echo "    run-dev"
	@echo "        Run the Play application in development mode"
	@echo "        See https://www.playframework.com/documentation/2.6.x/PlayConsole for more information"
	@echo "    run-prod"
	@echo "        Run the Play application in production mode"
	@echo "        See https://www.playframework.com/documentation/2.6.x/Deploying for more information"
	@echo "    test-all"
	@echo "        Execute all of the tests in the Scala project"
	@echo "    test-*-only TEST_ONLY=**"
	@echo "        Execute only the unit/integration/acceptance tests that match the wildcard in TEST_ONLY"
	@echo "    test-unit"
	@echo "        Execute the tests in the Scala project"
	@echo "    test-integration"
	@echo "        Execute the itests in the Scala project"
	@echo "    test-acceptance"
	@echo "        Execute the atests in the Scala project"

uninstall-docker:
	rm -rf .docker
	docker rmi --force sbt_environment_12

sbt: .docker/sbt_environment_12
	$(DOCKER_INTERACTIVE)

clean: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) clean

compile: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) compile

coverage-report: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) coverageReport

dependency-tree: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) dependencyTree

docker-stage: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) docker:stage

docker-publish-local: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) docker:publishLocal

format: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) scalafmt

lint: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) scalastyle

release: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) release

run-dev: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) run

run-prod: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) runProd

run: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) run

test-all: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) test itest:test atest:test

test-unit: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) test

test-unit-only: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) testOnly $(TEST_ONLY)

test-integration: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) itest:test

test-integration-only: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) itest:testOnly $(TEST_ONLY)

test-acceptance: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) atest:test

test-acceptance-only: $(SBT_RUN_PREREQUISITES)
	$(SBT_RUN) atest:testOnly $(TEST_ONLY)

.PHONY: help uninstall-docker sbt clean compile coverage-report dependency-tree docker-stage docker-publish-local format lint release run-dev run-prod test-all test-unit test-unit-only test-integration test-integration-only test-acceptance test-acceptance-only