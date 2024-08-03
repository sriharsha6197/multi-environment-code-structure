data "aws_ami" "ami" {
  most_recent = true
  name_regex = "Centos-8-DevOps-Practice"
  owners = [973714476881]
}
data "aws_security_group" "id_sg"{
  id = var.security_group_id
}
variable "security_group_id" {
  default = "sg-0139220bdae9b38db"
}
