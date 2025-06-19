# DevSecOps Bootstrap Guide

---

## Prerequisites

- **Google Cloud Platform (GCP) Account** with permissions to create projects, IAM roles, and resources
- **GitHub Account**
- **gcloud CLI** ([Install Guide](https://cloud.google.com/sdk/docs/install))
- **Terraform** ([Install Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
- **kubectl** ([Install Guide](https://kubernetes.io/docs/tasks/tools/))
- **Optional:** [Helm](https://helm.sh/docs/intro/install/) for advanced Kubernetes add-on management

---

## 1. Clone the Repository

```bash
git clone <your-repo-url>
cd devsecops-challenge
```

---

## 2. Authenticate with GCP

```bash
make google-login
```

This will open a browser window for you to authenticate with your Google account.

---

## 3. Create a GCP Project (Optional)

If you want to create a new project:

```bash
make create-project
```

Or, set your existing project as default:

```bash
gcloud config set project <your-gcp-project-id>
```

---

## 4. Create the Terraform State Bucket

```bash
make create-bucket
```

This will create a GCS bucket for storing Terraform state securely.

---

## 5. Set Up the GitHub Actions Service Account

```bash
make setup-gh-service-account
```

This will create a service account, assign required roles, and generate a key file (`github-actions-key.json`).

- **Upload the contents of `github-actions-key.json` to your GitHub repository secrets** as `GCP_SA_KEY`.

---

## 6. Configure Terraform Variables

Edit `terraform/terraform.tfvars` to set your project-specific values (project_id, region, etc.).

---

## 7. Initialize and Deploy Infrastructure

You can run these steps locally or let GitHub Actions handle them:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Or, push your changes to GitHub and let the CI/CD pipeline deploy the infrastructure automatically.


