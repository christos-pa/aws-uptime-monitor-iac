locals {
  safe_prefix = lower(replace(var.name_prefix, "_", "-"))

  common_tags = merge(
    {
      Project     = "aws-uptime-monitor-iac"
      ManagedBy   = "terraform"
      Environment = "dev"
    },
    var.tags
  )
}
