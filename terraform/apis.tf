resource "google_project_service" "required_apis" {
  for_each = var.required_apis

  project = var.project_id
  service = each.value

  disable_dependent_services = true
  disable_on_destroy         = false
}