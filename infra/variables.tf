variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-west-2"
}

variable "name_prefix" {
  description = "Unique prefix for all resources (keep it consistent across this repo)"
  type        = string
}

variable "alert_email" {
  description = "Email address to subscribe to SNS alerts"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "check_url" {
  description = "URL to check for uptime"
  type        = string
}

variable "timeout_seconds" {
  description = "HTTP timeout for checks"
  type        = number
  default     = 5
}

variable "schedule_expression" {
  description = "How often to run the uptime check (EventBridge expression)"
  type        = string
  default     = "rate(1 minute)"
}
