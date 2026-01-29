# main.tf

# --- 1. IAM Role for the Lambda Function ---
# This role allows the Lambda function to be invoked and to write logs to CloudWatch.
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.lambda_function_name}-exec-role"

  # The trust policy that allows Lambda to assume this role
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach the basic Lambda execution policy to write logs
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# --- 2. Package and Deploy the Lambda Function ---

# This data source zips up our INLINE Python code for deployment
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_inline_code.zip"

  # --- THIS IS THE KEY FOR INLINE CODE ---
  # Instead of 'source_file', we use 'content' to define the file directly.
  source {
    content  = <<-EOT
import os
import json

def lambda_handler(event, context):
    # Read the S3 Bucket ARN from the environment variable
    s3_bucket_arn = os.environ.get('S3_BUCKET_ARN', 'S3_BUCKET_ARN not set!')
    
    print(f"Hello from an INLINE Lambda function!")
    print(f"This function is configured for bucket ARN: {s3_bucket_arn}")
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Successfully retrieved S3 Bucket ARN: {s3_bucket_arn}')
    }
EOT
    filename = "handler.py" # The name of the file inside the zip archive
  }
  # ----------------------------------------
}

# This is the Lambda Function resource itself
resource "aws_lambda_function" "example_lambda" {
  function_name = var.lambda_function_name

  # --- Deployment Package ---
  # We still use 'filename' to point to the zip file created by the archive_file data source
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # --- Execution Configuration ---
  handler = "handler.lambda_handler" # Corresponds to filename.function_name
  runtime = "python3.9"
  role    = aws_iam_role.lambda_exec_role.arn

  # --- Passing the S3 Bucket ARN as an Environment Variable ---
  environment {
    variables = {
      S3_BUCKET_ARN = var.s3_bucket_arn # Consuming the input variable
    }
  }

  tags = {
    ManagedBy = "Terraform"
  }
}
