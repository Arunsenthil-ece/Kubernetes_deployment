resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

resource "aws_instance" "Controlplane" {
  ami           = var.ami_id
  instance_type = var.controlplane_instance
  tags          = local.controlplane_tags
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [ "${aws_security_group.kubernetes.id}" ]
}

resource "aws_instance" "Worker" {
  ami           = var.ami_id
  instance_type = var.worker_instance
  count         = var.worker_nodes
  tags          = merge(
    local.worker_tags,
    {
      Name = format("worker-%02d", count.index + 1)
    }
  )
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [ "${aws_security_group.kubernetes.id}" ]
}

