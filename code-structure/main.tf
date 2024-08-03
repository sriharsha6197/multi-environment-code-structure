module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.cidr_block
  cidr_blocks = var.cidr_blocks
  env = var.env
  private_blocks = var.private_blocks
  azs = var.azs
}
