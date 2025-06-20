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
	bash helpers/service-account.sh