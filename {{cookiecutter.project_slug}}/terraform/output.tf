output "{{cookiecutter.project_slug}}_bastion_ip" {
  value = "${aws_instance.{{cookiecutter.project_slug}}_bastion.public_ip}"
}

output "{{cookiecutter.project_slug}}_database_address" {
  value = "${aws_db_instance.{{cookiecutter.project_slug}}_db.address}"
}
