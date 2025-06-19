# Terraform Infrastructure

This directory contains the Terraform configuration for deploying a secure k3s cluster on GCP.

## File Structure

```
terraform/
├── main.tf              # Main configuration, provider setup, API enablement
├── versions.tf          # Terraform and provider version constraints
├── variables.tf         # Input variables
├── terraform.tfvars     # Variable values (project-specific)
├── outputs.tf           # Output values
├── network.tf           # VPC, subnets, firewall rules, NAT gateway
├── iam.tf              # Service accounts and IAM permissions
├── compute.tf          # VM instance configuration
└── scripts/
    └── k3s-install.sh           # k3s installation script
```

## Features

- **Private VM**: No external IP, access via Identity-Aware Proxy (IAP)
- **Network Security**: VPC with private subnets, NAT gateway for outbound access
- **k3s Installation**: Lightweight Kubernetes distribution with basic security

## Usage

1. Configure your project ID in `terraform.tfvars`
2. Initialize Terraform: `terraform init`
3. Plan deployment: `terraform plan`
4. Apply configuration: `terraform apply`

## Access

Connect to the VM via IAP:
```bash
gcloud compute ssh k3s-vm --zone=europe-west1-b --tunnel-through-iap
```

## Variables

- `project_id`: GCP Project ID
- `region`: GCP Region (default: europe-west1)
- `zone`: GCP Zone (default: europe-west1-b)
- `machine_type`: VM machine type (default: e2-medium)
