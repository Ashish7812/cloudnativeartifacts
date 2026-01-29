# variables.tf

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket that this Lambda function will consume."
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
  default     = "sahoa-example-inline-lambda"
}
