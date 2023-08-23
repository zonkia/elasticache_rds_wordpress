resource "aws_efs_file_system" "terra-efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "terra-EFS"
  }
}

resource "aws_efs_mount_target" "terra-efs-mount-a" {
  file_system_id  = aws_efs_file_system.terra-efs.id
  subnet_id       = aws_subnet.terra-private-subnet1.id
  security_groups = ["${aws_security_group.terra-efs-sg.id}"]
  depends_on = [
    aws_efs_file_system.terra-efs
  ]
}

resource "aws_efs_mount_target" "terra-efs-mount-b" {
  file_system_id  = aws_efs_file_system.terra-efs.id
  subnet_id       = aws_subnet.terra-private-subnet2.id
  security_groups = ["${aws_security_group.terra-efs-sg.id}"]
  depends_on = [
    aws_efs_file_system.terra-efs
  ]
}