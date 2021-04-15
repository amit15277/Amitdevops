output "alb_arn" {
  value       = aws_lb.alb.arn
  description = "alb arn"
}
output tg_arn {
  value = aws_lb_target_group.tg.arn
}