provider "aws" {
  region = "${var.aws_region}"
}

#
# Key-Pair:
#

resource "aws_key_pair" "{{cookiecutter.project_slug}}" {
  key_name   = "{{cookiecutter.project_slug}}-public-key"
  public_key = "${file("${var.public_key_path}")}"
}

#
# Network:
#

resource "aws_vpc" "{{cookiecutter.project_slug}}" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "{{cookiecutter.project_slug}}-vpc"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_internet_gateway" "{{cookiecutter.project_slug}}" {
  vpc_id = "${aws_vpc.{{cookiecutter.project_slug}}.id}"

  tags = {
    Name        = "{{cookiecutter.project_slug}}-ig"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_subnet" "{{cookiecutter.project_slug}}_public" {
  vpc_id                  = "${aws_vpc.{{cookiecutter.project_slug}}.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "{{cookiecutter.project_slug}}-public-subnet"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_subnet" "{{cookiecutter.project_slug}}_private_1" {
  vpc_id                  = "${aws_vpc.{{cookiecutter.project_slug}}.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name        = "{{cookiecutter.project_slug}}-private-subnet-1"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_subnet" "{{cookiecutter.project_slug}}_private_2" {
  vpc_id                  = "${aws_vpc.{{cookiecutter.project_slug}}.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name        = "{{cookiecutter.project_slug}}-private-subnet-2"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_eip" "{{cookiecutter.project_slug}}_nat_eip" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.8"

  tags = {
    Name        = "{{cookiecutter.project_slug}}-nat-eip"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_nat_gateway" "{{cookiecutter.project_slug}}_nat_gw" {
  allocation_id = "${aws_eip.{{cookiecutter.project_slug}}_nat_eip.id}"
  subnet_id     = "${aws_subnet.{{cookiecutter.project_slug}}_public.id}"

  tags = {
    Name        = "{{cookiecutter.project_slug}}-nat-gw"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_route_table" "{{cookiecutter.project_slug}}_public" {
  vpc_id = "${aws_vpc.{{cookiecutter.project_slug}}.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.{{cookiecutter.project_slug}}.id}"
  }

  tags = {
    Name        = "{{cookiecutter.project_slug}}-public-rt"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_route_table_association" "{{cookiecutter.project_slug}}_public" {
  subnet_id      = "${aws_subnet.{{cookiecutter.project_slug}}_public.id}"
  route_table_id = "${aws_route_table.{{cookiecutter.project_slug}}_public.id}"
}

resource "aws_route_table" "{{cookiecutter.project_slug}}_private" {
  vpc_id = "${aws_vpc.{{cookiecutter.project_slug}}.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.{{cookiecutter.project_slug}}_nat_gw.id}"
  }

  tags = {
    Name        = "{{cookiecutter.project_slug}}-private-rt"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_route_table_association" "{{cookiecutter.project_slug}}_private_1" {
  subnet_id      = "${aws_subnet.{{cookiecutter.project_slug}}_private_1.id}"
  route_table_id = "${aws_route_table.{{cookiecutter.project_slug}}_private.id}"
}

resource "aws_route_table_association" "{{cookiecutter.project_slug}}_private_2" {
  subnet_id      = "${aws_subnet.{{cookiecutter.project_slug}}_private_2.id}"
  route_table_id = "${aws_route_table.{{cookiecutter.project_slug}}_private.id}"
}

#
# Security Groups:
#

resource "aws_security_group" "{{cookiecutter.project_slug}}_bastion" {
  name        = "{{cookiecutter.project_slug}}-bastion-sg"
  description = "Allow Inbound SSH Access"
  vpc_id      = "${aws_vpc.{{cookiecutter.project_slug}}.id}"

  # Allow Inbound SSH Access:
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Outbound Internet Access:
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_security_group" "{{cookiecutter.project_slug}}_app" {
  name        = "{{cookiecutter.project_slug}}-app-sg"
  description = "Allow Outbound Internet Access"
  vpc_id      = "${aws_vpc.{{cookiecutter.project_slug}}.id}"

  # Allow Inbound SSH Access:
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.{{cookiecutter.project_slug}}_bastion.id}"]
  }

  # Allow Outbound Internet Access:
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_security_group" "{{cookiecutter.project_slug}}_db" {
  name        = "{{cookiecutter.project_slug}}-database-sg"
  description = "Allow Inbound PostgreSQL Access"
  vpc_id      = "${aws_vpc.{{cookiecutter.project_slug}}.id}"

  # Allow Inbound PostgreSQL Access:
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.{{cookiecutter.project_slug}}_bastion.id}", "${aws_security_group.{{cookiecutter.project_slug}}_app.id}"]
  }

  # Allow Outbound Internet Access:
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "{{cookiecutter.project_slug}}"
  }
}

#
# Bastion:
#

resource "aws_instance" "{{cookiecutter.project_slug}}_bastion" {
  connection {
    user = "ubuntu"
    host = "${self.public_ip}"
  }

  instance_type          = "t3.micro"
  ami                    = "${lookup(var.aws_amis, var.aws_region)}"
  key_name               = "${aws_key_pair.{{cookiecutter.project_slug}}.id}"
  vpc_security_group_ids = ["${aws_security_group.{{cookiecutter.project_slug}}_bastion.id}"]
  subnet_id              = "${aws_subnet.{{cookiecutter.project_slug}}_public.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install postgresql-client"
    ]
  }

  tags = {
    Name        = "{{cookiecutter.project_slug}}-bastion"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

#
# Database:
#

resource "aws_db_subnet_group" "{{cookiecutter.project_slug}}_db" {
  name       = "{{cookiecutter.project_slug}}-database-subnet-group"
  subnet_ids = ["${aws_subnet.{{cookiecutter.project_slug}}_private_1.id}", "${aws_subnet.{{cookiecutter.project_slug}}_private_2.id}"]

  tags = {
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_db_instance" "{{cookiecutter.project_slug}}_db" {
  allocated_storage = 32
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "${var.db_engine_version}"
  instance_class    = "${var.db_instance_class}"
  name              = "${var.db_name}"
  username          = "${var.db_username}"
  password          = "${var.db_password}"

  # Extra Configurations:
  vpc_security_group_ids = ["${aws_security_group.{{cookiecutter.project_slug}}_db.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.{{cookiecutter.project_slug}}_db.id}"
  max_allocated_storage  = 0
  multi_az               = false
  skip_final_snapshot    = true

  tags = {
    Name        = "{{cookiecutter.project_slug}}-database"
    Environment = "{{cookiecutter.project_slug}}"
  }
}

#
# Backend:
#

resource "aws_elastic_beanstalk_application" "{{cookiecutter.project_slug}}_app" {
  name        = "{{cookiecutter.project_slug}}-elastic-beanstalk-app"
  description = "{{cookiecutter.project_slug}} Backend"

  tags = {
    Environment = "{{cookiecutter.project_slug}}"
  }
}

resource "aws_elastic_beanstalk_environment" "{{cookiecutter.project_slug}}_app" {
  name                = "{{cookiecutter.project_slug}}-elastic-beanstalk-environment"
  application         = "${aws_elastic_beanstalk_application.{{cookiecutter.project_slug}}_app.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.14.1 running Docker 18.09.9-ce"
  tier                = "WebServer"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.{{cookiecutter.project_slug}}.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.{{cookiecutter.project_slug}}_private_1.id},${aws_subnet.{{cookiecutter.project_slug}}_private_2.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${aws_subnet.{{cookiecutter.project_slug}}_public.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "false"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${aws_key_pair.{{cookiecutter.project_slug}}.id}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.app_instance_class}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${aws_security_group.{{cookiecutter.project_slug}}_app.id}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "HTTP_APPLICATION_SECRET"
    value     = "${var.app_http_secret}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_URL"
    value     = "jdbc:postgresql://${aws_db_instance.{{cookiecutter.project_slug}}_db.endpoint}/${var.db_name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_USER"
    value     = "${var.db_username}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_PASSWORD"
    value     = "${var.db_password}"
  }

  tags = {
    Environment = "{{cookiecutter.project_slug}}"
  }
}

#
# Frontend:
#

resource "aws_s3_bucket" "{{cookiecutter.project_slug}}_bucket" {
  bucket = "${var.app_domain}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name        = "{{cookiecutter.project_slug}}_bucket"
    Environment = "{{cookiecutter.project_slug}}"
  }
}
