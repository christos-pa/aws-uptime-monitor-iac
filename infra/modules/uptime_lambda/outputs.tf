output "lambda_arn" {
  value = aws_lambda_function.uptime_checker.arn
}

output "lambda_name" {
  value = aws_lambda_function.uptime_checker.function_name
}
