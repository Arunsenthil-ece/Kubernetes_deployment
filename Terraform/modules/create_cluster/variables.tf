locals {
  controlplane_tags = {
    Name    = "control-plane",
    Type = "master-node"
  }
  worker_tags = {
    Type = "worker-node"
  }
}

locals {
  my_ip = "## COPY YOUR PUBLIC IP HERE ##"
}

variable "ami_id" {
  type    = string
  description = "Image to be used in your nodes"
}

variable "controlplane_instance" {
  type    = string
  description = "AWS instance type of your control-plane node"
}

variable "worker_instance" {
  type    = string
  description = "AWS instance type of your worker node"
}

variable "public_key" {
   type = string
   description = "SSH key to login to the server ssh"
}

variable "worker_nodes" {
  type = number
  description = "Number of worker node"  
  default = 2
}
