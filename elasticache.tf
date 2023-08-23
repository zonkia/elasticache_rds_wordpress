resource "aws_elasticache_cluster" "terra-wordpress-cache" {
  cluster_id           = "terra-wordpress-cache"
  engine               = "memcached"
  node_type            = var.cache_size
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  port                 = var.memcached_port
  security_group_ids   = ["${aws_security_group.terra-memcached-sg.id}"]
  subnet_group_name    = aws_elasticache_subnet_group.terra-cache-subnet-group.name
}

resource "aws_elasticache_subnet_group" "terra-cache-subnet-group" {
  name       = "terra-cache-subnet-group"
  subnet_ids = [aws_subnet.terra-private-subnet1.id, aws_subnet.terra-private-subnet2.id, aws_subnet.terra-public-subnet1.id, aws_subnet.terra-public-subnet2.id]
}