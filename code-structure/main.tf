module "vpc" {
  source = "./modules/vpc"
  cidr_blocks = var.cidr_blocks
  env = var.env
  private_blocks = var.private_blocks
}