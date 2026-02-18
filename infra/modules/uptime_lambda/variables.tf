variable "name_prefix" {
  type = string
}

variable "check_url" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "timeout_seconds" {
  type    = number
  default = 5
}

variable "tags" {
  type = map(string)
}
