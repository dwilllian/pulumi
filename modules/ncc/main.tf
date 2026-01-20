resource "google_network_connectivity_hub" "this" {
  count       = var.create_hub ? 1 : 0
  project     = var.project_id
  name        = var.hub_name
  description = var.hub_description
  labels      = var.labels
}

resource "google_network_connectivity_spoke" "this" {
  count       = var.create_spoke ? 1 : 0
  project     = var.project_id
  name        = var.spoke_name
  location    = var.spoke_location
  hub         = var.hub_self_link
  description = var.spoke_description
  labels      = var.labels

  linked_vpc_network {
    uri                  = var.linked_vpc_network
    exclude_export_ranges = var.exclude_export_ranges
    include_export_ranges = var.include_export_ranges
  }
}
