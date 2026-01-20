resource "google_compute_router" "this" {
  count   = var.enable_nat ? 1 : 0
  name    = var.router_name
  project = var.project_id
  region  = var.region
  network = var.network
}

resource "google_compute_router_nat" "this" {
  count                               = var.enable_nat ? 1 : 0
  name                                = var.nat_name
  project                             = var.project_id
  region                              = var.region
  router                              = google_compute_router.this[0].name
  nat_ip_allocate_option              = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat  = var.source_subnetwork_ip_ranges_to_nat
  min_ports_per_vm                    = var.min_ports_per_vm
  udp_idle_timeout_sec                = var.udp_idle_timeout_sec
  icmp_idle_timeout_sec               = var.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec    = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.tcp_transitory_idle_timeout_sec
  enable_endpoint_independent_mapping = var.enable_endpoint_independent_mapping

  dynamic "subnetwork" {
    for_each = var.subnetworks
    content {
      name                    = subnetwork.value.name
      source_ip_ranges_to_nat = subnetwork.value.source_ip_ranges_to_nat
    }
  }
}
