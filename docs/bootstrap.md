# Bootstrap

Let's assume there is already a gcp project created with a billing account linked, but if not:

```shell

# Initialize new project

export PROJECT_ID="k3s-secure-demo-$(date +%s)"
gcloud projects create $PROJECT_ID$

# Setup Bucket for Terraform State

gsutil mb gs://k3s-terraform-state
# Enable versioning
gsutil versioning set on gs://k3s-terraform-state


# Initiate Terraform State
gcloud auth application-default login



````


