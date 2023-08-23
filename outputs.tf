output "amazon_ami" {
  value       = data.aws_ami.amazon-linux2.id
  description = "amazon_ami"
}

output "bitnami_ami" {
  value       = data.aws_ami.bitnami-wordpress.id
  description = "bitnami wordpress ami"
}

output "memchached_endpoint" {
  value       = aws_elasticache_cluster.terra-wordpress-cache.configuration_endpoint
  description = "memchached_endpoin"
}

output "frontend_loadbalancer_dnsname" {
  value       = aws_lb.terra-front-lb.dns_name
  description = "The priate IP of the backend"
}

output "public_bastion_ip" {
  value       = aws_instance.terra-bastion-instance.public_ip
  description = "The public IP of the bastion"
}