
resource "aws_lb" "alb" {
  idle_timeout               = var.lb_timeout
  internal                   = var.lb_internal
  load_balancer_type         = "application"
  name                       = var.lb_name
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_http2               = "true"
  enable_deletion_protection = false
  tags = {
    Name        = var.lb_name
    Environment = var.ENV
  }
}


resource "aws_lb_listener" "http" {
  count             = var.build_http_listeners ? length(var.http_ports) : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http_ports[count.index]
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener_rule" "http_uri" {
  count        = var.http_listner_rule_enabled ? length(var.uri_path) : 0
  listener_arn = aws_lb_listener.http[0].arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[count.index].arn
  }

  condition {
    path_pattern {
      values = ["/${var.uri_path[count.index]}/*", "/${upper(var.uri_path[count.index])}/*" ,"/${var.uri_path[count.index]}" , "/${upper(var.uri_path[count.index])}"]
    }
  }
}



resource "aws_lb_target_group" "tg" {
  lifecycle {
    create_before_destroy = true
  }
name     = "${var.lb_name}-default"
  port     = var.tg_port
  deregistration_delay = "60"
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    Name            = "${var.lb_name}-default-tg"
    Environment     = var.ENV
  }
}

