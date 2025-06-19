# K3s VM Instance
resource "google_compute_instance" "this" {
  name         = "k3s-vm"
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  tags = var.tags

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.this.self_link
    subnetwork = google_compute_subnetwork.this.self_link
  }

  service_account {
    email  = google_service_account.this.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = file("${path.module}/scripts/k3s-install.sh")

  depends_on = [
    google_project_service.required_apis,
    google_compute_subnetwork.this,
    google_service_account.this
  ]
}