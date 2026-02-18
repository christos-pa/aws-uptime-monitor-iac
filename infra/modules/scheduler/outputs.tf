output "rule_name" {
  value = aws_cloudwatch_event_rule.uptime_schedule.name
}

output "rule_arn" {
  value = aws_cloudwatch_event_rule.uptime_schedule.arn
}
