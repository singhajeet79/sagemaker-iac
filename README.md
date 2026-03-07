# sagemaker-iac

## Overview

`sagemaker-iac` is a production-grade Machine Learning Platform Control Plane built on AWS using Terraform and GitOps principles.

This repository provisions and governs the infrastructure required to support:

- Continuous model training
- Model registry & lifecycle automation
- GitOps-based model deployment
- Observability-driven ML operations
- Secure, environment-isolated ML workloads

This is not a single ML project.
This is reusable ML Platform-as-Code.

---

## Core Objectives

- Infrastructure modularity
- Least-privilege IAM enforcement
- Environment promotion (dev → staging → prod)
- GitOps-first Kubernetes deployment (ArgoCD)
- Automated retraining pipelines
- Drift-aware model observability

---

## Architecture Layers

1. **Infrastructure Layer**
   - VPC networking (private subnets)
   - EKS cluster
   - SageMaker domain
   - IAM boundary model
   - S3 data lake
   - ECR repositories

2. **Platform Layer**
   - ArgoCD bootstrap
   - Helm-based service deployment
   - MLflow stack
   - Observability stack (Prometheus + Grafana)

3. **ML Lifecycle Layer**
   - Event-driven retraining
   - Model evaluation gates
   - Registry-based promotion
   - Zero-downtime rollout

---

## Repository Structure

terraform/ Infrastructure modules and environments
platform/ GitOps bootstrap and Helm applications
ml-platform/ Reusable ML lifecycle tooling
observability/ Monitoring stack and dashboards
cicd/ CI/CD automation definitions
examples/ Reference ML workloads
docs/ Architecture and operational runbooks

---

## Deployment Philosophy

- Modules represent capabilities
- Environments represent composition
- No manual kubectl in production
- Infrastructure changes require review
- Model promotion is automated and gated

---

## Environments

- dev
- staging
- prod

Each environment maintains isolated state and configuration.

---

## Engineering Standards

- Pre-commit enforced validation
- Security scanning (Checkov)
- Terraform linting (tflint)
- Immutable artifacts
- GitOps-based workload deployment

---

## Target Audience

Internal ML teams that require:

- Secure training environments
- Automated deployment pipelines
- Observability for model health
- Governance-ready infrastructure

---

## Status

Platform under active development.

---

## 👨‍💻 Author
Ajeet Singh — DevOps & Platform Engineering
https://github.com/singhajeet79
