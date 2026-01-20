resource "google_project" "this" {
  count           = var.create_project ? 1 : 0
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account
  labels          = var.labels
}

resource "google_project_service" "services" {
  for_each           = toset(var.enable_apis)
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false

  depends_on = [google_project.this]
}
