# VPC Network
resource "google_compute_network" "this" {
  name                    = "k3s-network"
  auto_create_subnetworks = false
  project                 = var.project_id

  depends_on = [google_project_service.required_apis]
}


resource "google_compute_subnetwork" "this" {
  name          = "k3s-subnet"
  ip_cidr_range = var.network_cidr
  region        = var.region
  network       = google_compute_network.this.id
  project       = var.project_id

  # Enable private Google access for VM without external IP
  private_ip_google_access = true
}

resource "google_compute_router" "this" {
  name    = "k3s-router"
  region  = var.region
  network = google_compute_network.this.id
  project = var.project_id
}

resource "google_compute_router_nat" "this" {
  name    = "k3s-nat"
  router  = google_compute_router.this.name
  region  = var.region
  project = var.project_id

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.this.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "this" {
  name      = "allow-iap"
  network   = google_compute_network.this.name
  direction = "INGRESS"
  project   = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # IAP Range
  source_ranges = ["35.235.240.0/20"]
  target_tags   = var.tags
}
