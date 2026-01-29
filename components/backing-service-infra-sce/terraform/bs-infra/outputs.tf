# outputs.tf

output "s3_bucket_id" {
  description = "The name (id) of the S3 bucket."
  value       = aws_s3_bucket.my_simple_bucket.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.my_simple_bucket.arn
}
