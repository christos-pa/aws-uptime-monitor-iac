variable "name_prefix" {
  type = string
}

variable "alert_email" {
  description = "Email address to receive SNS alerts"
  type        = string
}

variable "tags" {
  type = map(string)
}
