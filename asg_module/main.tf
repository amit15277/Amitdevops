resource "aws_autoscaling_group" "this" {
  name                 = "${var.name}-asg"
  min_size             = var.asg_min
  max_size             = var.asg_max
  desired_capacity     = var.asg_desired
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.subnets
}
resource "aws_launch_configuration" "this" {
  name                        = "${var.name}-lc"
  image_id                    = "ami-0a4a70bd98c6d6441"
  instance_type               = var.instance_type
  security_groups             = var.security_groups
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\nsudo apt install apache2 -y \n sudo service apache2 start"
}

resource "aws_key_pair" "this" {
  key_name   = "${var.name}_key_pair"
  public_key = file(var.ssh_pubkey_file)
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  alb_target_group_arn   = var.alb_arn
}
resource "aws_autoscaling_policy" "this" {
  name                   = "${var.name}-asg-policy"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
}
resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = "${var.name}-asg-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.this.arn]
}