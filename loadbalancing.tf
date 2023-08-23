resource "aws_lb" "terra-front-lb" {
  name               = "terra-front-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.terra-front-sg.id}"]
  subnets            = [aws_subnet.terra-public-subnet1.id, aws_subnet.terra-public-subnet2.id]

  enable_deletion_protection = false

  tags = {
    Name = "terra-front-lb"
  }
}

resource "aws_lb_target_group" "terra-front-target-group" {
  name     = "terra-front-target-group"
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.terra-vpc.id
}

resource "aws_lb_listener" "terra-front-listener" {
  load_balancer_arn = aws_lb.terra-front-lb.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terra-front-target-group.arn
  }
}

resource "aws_launch_configuration" "terra-front-lc" {
  image_id        = data.aws_ami.bitnami-wordpress.id
  instance_type   = var.asg_instance_size
  security_groups = ["${aws_security_group.terra-back-sg.id}"]
  key_name        = var.key_pair_name
  user_data = templatefile("./scripts/data_asg.sh", {
    efs_dns = "${aws_efs_file_system.terra-efs.dns_name}"
  })
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_instance.terra-wp-launch
  ]

}

resource "aws_autoscaling_group" "terra-front-asg" {
  launch_configuration = aws_launch_configuration.terra-front-lc.id
  min_size             = var.min_asg_size
  max_size             = var.max_asg_size
  target_group_arns    = [aws_lb_target_group.terra-front-target-group.arn]
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_subnet.terra-private-subnet1.id, aws_subnet.terra-private-subnet2.id]
  tag {
    key                 = "Name"
    value               = "terra-front-asg"
    propagate_at_launch = true
  }
  depends_on = [
    aws_instance.terra-wp-launch
  ]
}

resource "aws_autoscaling_policy" "terra-front-scale-down" {
  name                   = "terra-front-scale-down"
  autoscaling_group_name = aws_autoscaling_group.terra-front-asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "terra-front-scale-down-metric-alarm" {
  alarm_description   = "Monitors CPU utilization for Frontend ASG"
  alarm_actions       = [aws_autoscaling_policy.terra-front-scale-down.arn]
  alarm_name          = "frontend_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terra-front-asg.name
  }
}

resource "aws_autoscaling_policy" "terra-front-scale-up" {
  name                   = "terra-front-scale-up"
  autoscaling_group_name = aws_autoscaling_group.terra-front-asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "terra-front-scale-up-metric-alarm" {
  alarm_description   = "Monitors CPU utilization for Frontend ASG"
  alarm_actions       = [aws_autoscaling_policy.terra-front-scale-up.arn]
  alarm_name          = "frontend_scale_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "60"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terra-front-asg.name
  }
}
