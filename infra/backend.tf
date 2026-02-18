terraform {
  backend "s3" {
    bucket         = "uptime-iac-christos-v2-088878891653-tfstate-eu-west-2"
    key            = "aws-uptime-monitor-iac/infra/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "uptime-iac-christos-v2-tflock"
    encrypt        = true
  }
}
