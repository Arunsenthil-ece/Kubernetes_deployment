data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "kubernetes" {
  name        = "kube-security"
  description = "Allow TLS inbound traffic and all outbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.kubernetes.id
  cidr_ipv4         = local.my_ip
  ip_protocol       = "tcp"
  to_port           = 22
  from_port         = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
  security_group_id = aws_security_group.kubernetes.id
  cidr_ipv4         = local.my_ip
  ip_protocol       = "icmp"
  to_port           = -1
  from_port         = -1
}

resource "aws_vpc_security_group_ingress_rule" "allow_kube" {
  security_group_id = aws_security_group.kubernetes.id
  cidr_ipv4         = data.aws_vpc.default.cidr_block
  ip_protocol       = "tcp"
  to_port           = 6443
  from_port         = 6443
}


resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.kubernetes.id
    from_port   = -1
    to_port     = -1
    ip_protocol  = "-1"           # "-1" means ALL protocols
    cidr_ipv4 = "0.0.0.0/0" # Destination: Everywhere
}

