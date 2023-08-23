resource "tls_private_key" "terra-private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terra-key-pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.terra-private-key.public_key_openssh
}

resource "local_file" "terra-ssh-key" {
  filename = "${aws_key_pair.terra-key-pair.key_name}.pem"
  content = tls_private_key.terra-private-key.private_key_pem
}