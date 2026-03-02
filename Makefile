# ==========================================
# ML PLATFORM CONTROL PLANE - MAKEFILE
# ==========================================

ENV ?= dev
TF_DIR=terraform/environments/$(ENV)

.PHONY: help init plan apply destroy fmt validate lint

help:
	@echo "Usage:"
	@echo "  make init ENV=dev"
	@echo "  make plan ENV=dev"
	@echo "  make apply ENV=dev"
	@echo "  make destroy ENV=dev"
	@echo "  make fmt"
	@echo "  make validate"
	@echo "  make lint"

# ------------------------------------------
# Terraform Environment Operations
# ------------------------------------------

init:
	cd $(TF_DIR) && terraform init

plan:
	cd $(TF_DIR) && terraform plan

apply:
	cd $(TF_DIR) && terraform apply

destroy:
	cd $(TF_DIR) && terraform destroy

# ------------------------------------------
# Quality & Formatting
# ------------------------------------------

fmt:
	terraform fmt -recursive

validate:
	cd $(TF_DIR) && terraform validate

lint:
	pre-commit run --all-files
