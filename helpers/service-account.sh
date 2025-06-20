#!/usr/bin/env bash

set -eou pipefail

export PROJECT_ID=$(gcloud config get-value project)
export SA_DISPLAY_NAME="GitHub Actions"
export SA_NAME="github-actions"

if ! command -v gcloud &> /dev/null; then
  echo "gcloud could not installed, exiting..."
  exit 1
fi

if [ -z "$PROJECT_ID" ]; then
  echo "PROJECT_ID is not set, exiting..."
  exit 1
fi

gcloud iam service-accounts create $SA_NAME \
  --project $PROJECT_ID \
  --display-name "$SA_DISPLAY_NAME"

sleep 5

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectIamAdmin"

gcloud iam service-accounts keys create github-actions-key.json \
  --iam-account "$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --project $PROJECT_ID