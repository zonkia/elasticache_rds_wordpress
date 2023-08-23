resource "aws_db_subnet_group" "terra-mysql-subnet-group" {
  name       = "terra-mysql-subnet-group"
  subnet_ids = [aws_subnet.terra-private-subnet1.id, aws_subnet.terra-private-subnet2.id, aws_subnet.terra-public-subnet1.id, aws_subnet.terra-public-subnet2.id]
}

resource "aws_db_instance" "terra-rds-mysql" {
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  backup_retention_period = var.db_backup_retention_period
  db_name                 = var.db_name
  engine                  = var.db_engine
  instance_class          = var.db_instance_size
  username                = var.mysql_user
  password                = var.mysql_pass
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.terra-mysql-subnet-group.id
  multi_az                = var.db_multi_az
  vpc_security_group_ids  = ["${aws_security_group.terra-mysql-sg.id}"]
  publicly_accessible     = false
}