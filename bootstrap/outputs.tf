output "tf_state_bucket_name" {
  value       = aws_s3_bucket.tf_state.bucket
  description = "Name of the S3 bucket for Terraform remote state"
}

output "tf_lock_table_name" {
  value       = aws_dynamodb_table.tf_lock.name
  description = "Name of the DynamoDB table for Terraform state locking"
}

output "aws_region" {
  value       = var.aws_region
  description = "AWS region used for bootstrap"
}
