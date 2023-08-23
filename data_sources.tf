data "aws_ami" "amazon-linux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "bitnami-wordpress" {
  most_recent = true
  owners      = [979382823631]
  filter {
    name   = "name"
    values = ["bitnami-wordpresspro-*-linux-debian-11-x86_64-hvm-ebs-nami"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}