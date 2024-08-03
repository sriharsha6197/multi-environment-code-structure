env = "prod"
azs = ["us-east-1c","us-east-1e"]
cidr_block = "10.40.0.0/16"
cidr_blocks = ["10.40.1.0/24","10.40.2.0/24"]
private_blocks = ["10.40.3.0/24","10.40.4.0/24"]
data "aws_security_group" "id_sg"{
  id = var.security_group_id
}
variable "security_group_id" {
  default = "sg-0139220bdae9b38db"
}