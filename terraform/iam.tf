resource "google_service_account" "this" {
  account_id   = "${var.name}-vm-sa"
  display_name = "K3s VM Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "monitoring_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.this.email}"
}