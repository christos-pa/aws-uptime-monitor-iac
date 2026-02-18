module "network" {
  source      = "./modules/network"
  name_prefix = var.name_prefix
  aws_region  = var.aws_region
  tags        = local.common_tags
}

module "web" {
  source      = "./modules/web"
  name_prefix = var.name_prefix
  subnet_id   = module.network.public_subnet_id
  vpc_id      = module.network.vpc_id
  tags        = local.common_tags
}

output "web_public_ip" {
  value = module.web.public_ip
}

module "alerts" {
  source      = "./modules/alerts"
  name_prefix = var.name_prefix
  alert_email = var.alert_email
  tags        = local.common_tags
}

output "sns_topic_arn" {
  value = module.alerts.topic_arn
}

module "uptime_lambda" {
  source          = "./modules/uptime_lambda"
  name_prefix     = var.name_prefix
  check_url       = var.check_url
  sns_topic_arn   = module.alerts.topic_arn
  timeout_seconds = var.timeout_seconds
  tags            = local.common_tags
}

output "lambda_name" {
  value = module.uptime_lambda.lambda_name
}

module "scheduler" {
  source              = "./modules/scheduler"
  name_prefix         = var.name_prefix
  schedule_expression = var.schedule_expression
  lambda_arn          = module.uptime_lambda.lambda_arn
  lambda_name         = module.uptime_lambda.lambda_name
  tags                = local.common_tags
}

output "eventbridge_rule_name" {
  value = module.scheduler.rule_name
}
