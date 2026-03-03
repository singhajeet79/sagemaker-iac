locals {
  base_tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
    ManagedBy   = "Terraform"
    Repository  = "sagemaker-iac"
  }

  merged_tags = merge(local.base_tags, var.additional_tags)

  name_prefix = "${var.project}-${var.environment}"
}
