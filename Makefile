google-login:
	gcloud auth application-default login

create-project:
	export PROJECT_ID="k3s-secure-demo-$(date +%s)"
	echo "Creating project $PROJECT_ID..."
	gcloud projects create $PROJECT_ID$

create-bucket:
	gsutil mb gs://k3s-terraform-state
	gsutil versioning set on gs://k3s-terraform-state

setup-gh-service-account:
	PROJECT_ID=$$(gcloud config get-value project) && \
	SA_DISPLAY_NAME="GitHub Actions" && \
	SA_NAME=github-actions && \
	gcloud iam service-accounts create $$SA_NAME \
		--project $$PROJECT_ID \
		--display-name "$$SA_DISPLAY_NAME" && \
	gcloud projects add-iam-policy-binding $$PROJECT_ID \
		--member="serviceAccount:$$SA_NAME@$$PROJECT_ID.iam.gserviceaccount.com" \
		--role="roles/editor" && \
	gcloud projects add-iam-policy-binding $$PROJECT_ID \
		--member="serviceAccount:$$SA_NAME@$$PROJECT_ID.iam.gserviceaccount.com" \
		--role="roles/storage.admin" && \
	gcloud projects add-iam-policy-binding $$PROJECT_ID \
		--member="serviceAccount:$$SA_NAME@$$PROJECT_ID.iam.gserviceaccount.com" \
		--role="roles/resourcemanager.projectIamAdmin" && \
	gcloud iam service-accounts keys create github-actions-key.json \
		--iam-account "$$SA_NAME@$$PROJECT_ID.iam.gserviceaccount.com" \
		--project $$PROJECT_ID