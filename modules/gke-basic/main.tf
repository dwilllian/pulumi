resource "google_container_cluster" "this" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.location

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_secondary_range_name
    services_secondary_range_name = var.service_secondary_range_name
  }

  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  release_channel {
    channel = var.release_channel
  }

  master_authorized_networks_config {
    cidr_blocks = var.master_authorized_networks
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  node_config {
    service_account = var.node_service_account
    tags            = var.node_tags
    labels          = var.node_labels
    oauth_scopes    = var.node_oauth_scopes

    shielded_instance_config {
      enable_secure_boot = true
    }
  }

  resource_labels = var.labels
}

resource "google_container_node_pool" "primary" {
  name       = var.node_pool_name
  project    = var.project_id
  location   = var.location
  cluster    = google_container_cluster.this.name
  node_count = var.node_count

  node_config {
    machine_type    = var.machine_type
    disk_size_gb    = var.disk_size_gb
    disk_type       = var.disk_type
    service_account = var.node_service_account
    tags            = var.node_tags
    labels          = var.node_labels
    oauth_scopes    = var.node_oauth_scopes

    shielded_instance_config {
      enable_secure_boot = true
    }
  }

  dynamic "autoscaling" {
    for_each = var.enable_autoscaling ? [1] : []
    content {
      min_node_count = var.autoscaling_min_node_count
      max_node_count = var.autoscaling_max_node_count
    }
  }

  management {
    auto_upgrade = var.auto_upgrade
    auto_repair  = var.auto_repair
  }

  lifecycle {
    precondition {
      condition     = var.enable_autoscaling ? (var.autoscaling_min_node_count != null && var.autoscaling_max_node_count != null) : true
      error_message = "Autoscaling min/max node counts must be set when autoscaling is enabled."
    }
  }

  depends_on = [google_container_cluster.this]
}
