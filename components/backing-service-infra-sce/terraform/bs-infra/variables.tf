# variables.tf

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique across ALL AWS accounts."
  type        = string
}

# (Optional) If you want to explicitly define the region in variables
# variable "region" {
#   description = "The AWS region where the bucket will be created."
#   type        = string
#   default     = "us-east-1" # Set your desired default region
# }
