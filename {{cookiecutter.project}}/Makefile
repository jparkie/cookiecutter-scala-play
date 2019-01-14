SHELL := /bin/bash

TEST_ONLY = **

DOCKER_BASE = docker run \
	--volume $$(pwd):/repo \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	--volume $(HOME)/.sbt:/root/.sbt \
	--volume $(HOME)/.ivy2:/root/.ivy2 \
	--publish 9000:9000

DOCKER_RUN = $(DOCKER_BASE) \
	sbt_environment_12

DOCKER_INTERACTIVE = $(DOCKER_BASE) \
	--interactive \
	--tty \
	--entrypoint bash \
	sbt_environment_12

COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES ?= .docker/sbt_environment_12
COOKIECUTTER_SCALA_PLAY_RUN ?= $(DOCKER_RUN)

.docker/sbt_environment_12: Dockerfile
	docker build --tag sbt_environment_12 --file Dockerfile .
	mkdir -p .docker
	touch .docker/sbt_environment_12

.pre-commit:
	curl https://pre-commit.com/install-local.py | python -
	$(HOME)/bin/pre-commit install
	touch .pre-commit

help:
	@echo "Welcome to {{cookiecutter.project}}!"
	@echo ""
	@echo "This project is preferably managed with Docker. Please have Docker installed."
	@echo ""
	@echo "Otherwise, please install pre-commit, sbt, scalafmt, and scalastyle."
	@echo ""
	@echo "Please source project/use-local-sbt.sh if you want the Makefile to use the local sbt"
	@echo "Please source project/use-docker-sbt.sh if you want the Makefile to use the Docker sbt"
	@echo ""
	@echo "    uninstall-docker"
	@echo "        Remove Docker image sbt_environment_12"
	@echo "    init"
	@echo "        Initialize project directory"
	@echo "    docker"
	@echo "        Start an interactive, Dockerized bash session"
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
	@echo "    pre-commit"
	@echo "        Execute pre-commit hooks"
	@echo "        See https://pre-commit.com/ for more information"
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

init: .pre-commit

docker: .docker/sbt_environment_12
	$(DOCKER_INTERACTIVE)

clean: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt clean

compile: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt compile

coverage-report: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt coverageReport

dependency-tree: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt dependencyTree

docker-stage: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt docker:stage

docker-publish-local: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt docker:publishLocal

format: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt scalafmt test:scalafmt itest:scalafmt atest:scalafmt

lint: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt scalastyle

pre-commit: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) pre-commit

release: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt release

run-dev: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt run

run-prod: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt runProd

test-all: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt test itest:test atest:test

test-unit: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt test

test-unit-only: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt testOnly $(TEST_ONLY)

test-integration: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt itest:test

test-integration-only: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt itest:testOnly $(TEST_ONLY)

test-acceptance: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt atest:test

test-acceptance-only: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) sbt atest:testOnly $(TEST_ONLY)

hook-scalafmt: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) scalafmt --git true --diff-branch $$(git branch | head -n1 | cut -d " "  -f2) --non-interactive

hook-scalastyle: $(COOKIECUTTER_SCALA_PLAY_RUN_PREREQUISITES)
	$(COOKIECUTTER_SCALA_PLAY_RUN) scalastyle --config scalastyle-config.xml src/ | (! grep -E "^(error|warning)")

.PHONY: help uninstall-docker init docker clean compile coverage-report dependency-tree docker-stage docker-publish-local format lint pre-commit release run-dev run-prod test-all test-unit test-unit-only test-integration test-integration-only test-acceptance test-acceptance-only hook-scalafmt hook-scalastyle