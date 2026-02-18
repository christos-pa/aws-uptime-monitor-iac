data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda_role" {
  name = "${var.name_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = merge(var.tags, { Name = "${var.name_prefix}-lambda-role" })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.name_prefix}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = var.sns_topic_arn
      }
    ]
  })
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.root}/lambda/uptime_checker"
  output_path = "${path.root}/lambda/uptime_checker.zip"
}

resource "aws_lambda_function" "uptime_checker" {
  function_name = "${var.name_prefix}-uptime-checker"
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.handler"
  runtime       = "python3.12"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout = 10

  environment {
    variables = {
      CHECK_URL        = var.check_url
      SNS_TOPIC_ARN    = var.sns_topic_arn
      TIMEOUT_SECONDS  = tostring(var.timeout_seconds)
    }
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-uptime-checker" })
}

resource "aws_cloudwatch_log_group" "lambda_lg" {
  name              = "/aws/lambda/${aws_lambda_function.uptime_checker.function_name}"
  retention_in_days = 14
  tags              = var.tags
}
