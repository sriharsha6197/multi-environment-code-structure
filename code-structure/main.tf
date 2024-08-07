module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.cidr_block
  cidr_blocks = var.cidr_blocks
  env = var.env
  private_blocks = var.private_blocks
  azs = var.azs
  peer_owner_id = var.peer_owner_id
  peer_vpc_id = var.peer_vpc_id
  vpc_id = var.cidr_block
}
