# Outputs

output "service_account_email" {
  description = "K3s VM service account email"
  value       = google_service_account.this.email
}

output "iap_ssh_command" {
  description = "Command to SSH via IAP"
  value       = "gcloud compute ssh ${google_compute_instance.this.name} --zone=${var.zone} --tunnel-through-iap"
}