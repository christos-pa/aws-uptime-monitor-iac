variable "name_prefix" {
  type = string
}

variable "schedule_expression" {
  description = "EventBridge schedule expression, e.g. rate(1 minute)"
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda function to invoke"
  type        = string
}

variable "lambda_name" {
  description = "Name of the Lambda function (needed for permissions)"
  type        = string
}

variable "tags" {
  type = map(string)
}
