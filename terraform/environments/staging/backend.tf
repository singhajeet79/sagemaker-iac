terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "sagemaker-iac-terraform-state"
    key            = "staging/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "sagemaker-iac-terraform-lock"
    encrypt        = true
  }
}
