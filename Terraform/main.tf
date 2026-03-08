provider "aws" {
  region                   = var.region
  profile                  = var.profile
  shared_config_files      = ["config"]
  shared_credentials_files = ["credentials"]
}

module "ec2_instances" {
  source ="./modules/create_cluster"
  ami_id = var.ami_id
  controlplane_instance = var.controlplane_instance
  worker_instance = var.worker_instance
  public_key = var.public_key
  worker_nodes = var.worker_nodes
}




