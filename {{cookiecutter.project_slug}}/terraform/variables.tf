variable "aws_region" {
  description = "The AWS region from which to deploy {{cookiecutter.project_slug}}."
  default     = "us-east-2"
}
variable "aws_amis" {
  description = "18.04 Ubuntu AMIs by AWS regions available to deploy {{cookiecutter.project_slug}}."
  default = {
    us-east-1 = "ami-07ebfd5b3428b6f4d"
    us-east-2 = "ami-0fc20dd1da406780b"
  }
}

variable "public_key_path" {
  description = "The path to the SSH public key to be used for authentication."
}

variable "db_engine_version" {
  description = "The PostgreSQL version to deploy"
  default     = "11.5"
}
variable "db_instance_class" {
  description = "The PostgreSQL instance class to deploy"
  default     = "db.t3.medium"
}
variable "db_name" {
  description = "The name of the PostgreSQL instance to deploy"
}
variable "db_username" {
  description = "The master username of the PostgreSQL instance to deploy"
}
variable "db_password" {
  description = "The master password of the PostgreSQL instance to deploy"
}

variable "app_domain" {
  description = "The {{cookiecutter.project_slug}} domain to deploy"
  default     = "{{cookiecutter.project_slug}}.ca"
}
variable "app_instance_class" {
  description = "The {{cookiecutter.project_slug}} instance class to deploy"
  default     = "t3.medium"
}
variable "app_http_secret" {
  description = "The Play framework's HTTP secret key used to encrypt {{cookiecutter.project_slug}}"
}
