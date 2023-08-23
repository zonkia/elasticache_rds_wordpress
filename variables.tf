# General variables
variable "my_ip" {
  description = "Limit possible IP range for ssh access"
  default     = "0.0.0.0/0"
}
variable "region" {
  description = "aws region"
  default     = "eu-central-1"
}
variable "key_pair_name" {
  description = "Key pair name"
  default     = "privateKey"
}
# EC2 variables
variable "cache_size" {
  description = "Cache instance size"
  default     = "cache.t4g.micro"
}
variable "instance_size" {
  description = "Instance size"
  default     = "t2.micro"
}
variable "asg_instance_size" {
  description = "ASG Instance size"
  default     = "t2.micro"
}
# RDS variables
variable "mysql_user" {
  description = "MYSQL user name"
  default     = "admin"
}
variable "mysql_pass" {
  description = "MYSQL password"
  default     = "wordpress-pass"
}
variable "db_user" {
  description = "Database user name"
  default     = "wordpress"
}
variable "db_pass" {
  description = "Database password"
  default     = "wordpress-pass"
}
variable "db_name" {
  description = "Database name"
  default     = "wordpress"
}
variable "db_instance_size" {
  description = "Database Instance size"
  default     = "db.t3.micro"
}
variable "db_engine" {
  description = "Database engine"
  default     = "mysql"  
}
variable "db_allocated_storage" {
  description = "Allocated db storage"
  type        = number
  default     = 200  
}
variable "db_max_allocated_storage" {
  description = "max allocated storage"
  type        = number
  default     = 1000
}
variable "db_backup_retention_period" {
  description = "How long to retain backup; 0 means off"
  type        = number
  default     =  0
}
variable "db_multi_az" {
  description = "True/False if database is Multi-AZ"
  type        = bool
  default     = false
}
# ASG variables
variable "min_asg_size" {
  description = "Minumum amount of instances in ASG"
  type        = number
  default     = 1
}
variable "max_asg_size" {
  description = "Minumum amount of instances in ASG"
  type        = number
  default     = 3
}
variable "max_cpu_for_scale_down" {
  description = "Max average % CPUUtilization for scale down action"
  type        = number
  default     = 10
}
variable "min_cpu_for_scale_down" {
  description = "Max average % CPUUtilization for scale down action"
  type        = number
  default     = 60
}
# Ports variables
variable "http_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}
variable "mysql_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 3306
}
variable "memcached_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 11211
}
variable "ssh_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 22
}
variable "https_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 443
}
variable "efs_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 2049
}