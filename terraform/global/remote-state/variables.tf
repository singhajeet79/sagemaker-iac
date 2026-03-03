variable "region" {
  description = "AWS region for remote state resources"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of DynamoDB table for state locking"
  type        = string
}
