variable "name" {
  description = "Prefix for all resources"
  type = string
  default = "k3s"
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-a"
}

variable "network_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "required_apis" {
  description = "Required APIS"
  type = set(string)
}

variable "machine_type" {
  description = "Machine type for k3s VM"
  type        = string
  default     = "e2-medium"
}

variable "tags" {
  description = "Tags"
  type = set(string)
}