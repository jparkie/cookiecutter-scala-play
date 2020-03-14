.docker/{{cookiecutter.project_slug}}:
	$(MAKE) -C ../ docker-publish-local
	mkdir -p .docker
	touch .docker/{{cookiecutter.project_slug}}

help:
	@echo "Welcome to tools!"
	@echo ""
	@echo "This folder stores all the Docker-related files required to launch a development environment."
	@echo ""
	@echo "Store relevant configurations within ./conf/dev.conf"
	@echo "Store relevant data within ./data"
	@echo "The ./workspace persists PostgreSQL between launches"
	@echo ""
	@echo "    uninstall-docker"
	@echo "        Remove Docker image example:"
	@echo "    up"
	@echo "        Start the development environment"
	@echo "    up-db"
	@echo "        Start only the development database"
	@echo "    down"
	@echo "        Stop the development environment"
	@echo "    attach-application"
	@echo "        Attach an interactive bash session to the application Docker container"
	@echo "    attach-database"
	@echo "        Attach an interactive bash session to the database Docker container"
	@echo "    attach-psql"
	@echo "        Attach psql to the database Docker container"

uninstall-docker:
	rm -rf .docker
	docker rmi --force local/{{cookiecutter.project_slug}}:latest

up: .docker/{{cookiecutter.project_slug}}
	docker-compose up

up-db: .docker/{{cookiecutter.project_slug}}
	docker-compose up {{cookiecutter.project_slug}}-database

down: .docker/{{cookiecutter.project_slug}}
	docker-compose down

attach-application:
	docker exec --interactive --tty {{cookiecutter.project_slug}}-application /bin/bash

attach-database:
	docker exec --interactive --tty {{cookiecutter.project_slug}}-database /bin/bash

attach-psql:
	docker exec --interactive --tty -e POSTGRES_PASSWORD={{cookiecutter.project_slug}} {{cookiecutter.project_slug}}-database /usr/local/bin/psql --username {{cookiecutter.project_slug}} --dbname {{cookiecutter.project_slug}}

.PHONY: help uninstall-docker up up-db down attach-application attach-database attach-psql
