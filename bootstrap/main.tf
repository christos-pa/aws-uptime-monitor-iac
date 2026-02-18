data "aws_caller_identity" "current" {}

locals {
  # S3 bucket names must be globally unique, lowercase, and safe.
  safe_prefix = lower(replace(var.name_prefix, "_", "-"))

  tf_state_bucket_name = "${local.safe_prefix}-${data.aws_caller_identity.current.account_id}-tfstate-${var.aws_region}"
  tf_lock_table_name   = "${local.safe_prefix}-tflock"
  common_tags = merge(
    {
      Project     = "aws-uptime-monitor-iac"
      ManagedBy   = "terraform"
      Environment = "dev"
    },
    var.tags
  )
}

resource "aws_s3_bucket" "tf_state" {
  bucket = local.tf_state_bucket_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = local.tf_lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.common_tags
}
