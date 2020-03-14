help:
	@echo "Welcome to terraform!"
	@echo ""
	@echo "This folder stores all the Terraform-related files required to launch a production environment."
	@echo ""
	@echo "Store relevant configurations within ./conf/deploy.conf"
	@echo ""
	@echo "    docker-stage"
	@echo "        Stage a ZIP file with the {{cookiecutter.project_slug}} application ready for AWS Elastic Beanstalk"
	@echo "    up"
	@echo "        Start the production environment"
	@echo "    down"
	@echo "        Stop the production environment"
	@echo "    attach-bastion"
	@echo "        Attach an interactive SSH session to the production Bastion machine"

docker-stage:
	$(MAKE) -C ../ docker-stage
	rm -rf stage
	mkdir -p stage
	cp ./conf/deploy.conf ../target/docker/stage/opt/docker/conf/
	cp ./conf/Dockerrun.aws.json ../target/docker/stage/
	sh -c 'pushd ../target/docker/stage/ && zip -r {{cookiecutter.project_slug}}.zip * && popd'
	cp ../target/docker/stage/{{cookiecutter.project_slug}}.zip stage/

up:
	terraform apply -var-file={{cookiecutter.project_slug}}.tfvars

down:
	terraform destroy -var-file={{cookiecutter.project_slug}}.tfvars

attach-bastion:
	ssh ubuntu@$$(terraform output {{cookiecutter.project_slug}}_bastion_ip)

.PHONY: help docker-stage up down attach-bastion
