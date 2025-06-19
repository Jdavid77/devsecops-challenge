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

