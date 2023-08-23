resource "aws_instance" "terra-nat-instance" {
  ami               = data.aws_ami.amazon-linux2.id
  instance_type     = var.instance_size
  user_data         = file("./scripts/data_nat.sh")
  key_name          = var.key_pair_name
  tags              = { Name = "terra-nat-instance" }
  subnet_id         = aws_subnet.terra-public-subnet2.id
  security_groups   = ["${aws_security_group.terra-nat-sg.id}"]
  source_dest_check = false
  depends_on = [
    aws_key_pair.terra-key-pair
  ]
}

resource "aws_instance" "terra-bastion-instance" {
  ami             = data.aws_ami.amazon-linux2.id
  instance_type   = var.instance_size
  key_name        = var.key_pair_name
  tags            = { Name = "terra-bastion-instance" }
  subnet_id       = aws_subnet.terra-public-subnet1.id
  security_groups = ["${aws_security_group.terra-front-sg.id}"]
}

resource "aws_instance" "terra-wp-launch" {
  ami                                  = data.aws_ami.bitnami-wordpress.id
  instance_type                        = var.instance_size

  user_data = (templatefile("./scripts/data_wplaunch.sh", {
    mysql_endpoint = "${aws_db_instance.terra-rds-mysql.address}"
    mysql_user     = var.mysql_user
    mysql_pass     = var.mysql_pass
    db_user        = var.db_user
    db_name        = var.db_name
    db_pass        = var.db_pass
    efs_dns        = "${aws_efs_file_system.terra-efs.dns_name}"
  }))

  key_name                             = var.key_pair_name
  tags                                 = { Name = "terra-wp-launch" }
  subnet_id                            = aws_subnet.terra-private-subnet1.id
  security_groups                      = ["${aws_security_group.terra-back-sg.id}"]
  instance_initiated_shutdown_behavior = "terminate"

  depends_on = [
    aws_instance.terra-nat-instance,
    aws_db_instance.terra-rds-mysql,
    aws_efs_mount_target.terra-efs-mount-a,
    aws_efs_mount_target.terra-efs-mount-b,
    aws_key_pair.terra-key-pair
  ]
}