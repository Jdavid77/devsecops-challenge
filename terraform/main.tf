/**
 * # k3S Secure Demo
 *
 */

terraform {
  backend "gcs" {
    bucket = "k3s-terraform-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "required_apis" {
  for_each = var.required_apis
  
  project = var.project_id
  service = each.value
  
  disable_dependent_services = true
  disable_on_destroy = false
}