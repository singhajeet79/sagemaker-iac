variable "project" {
  description = "Project name (e.g., sagemaker-iac)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "owner" {
  description = "Team or owner responsible for the resources"
  type        = string
}

variable "cost_center" {
  description = "Cost center identifier"
  type        = string
}

variable "additional_tags" {
  description = "Optional additional tags"
  type        = map(string)
  default     = {}
}
