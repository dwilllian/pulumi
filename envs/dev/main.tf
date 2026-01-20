terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0, < 8.0"
    }
  }

  backend "gcs" {}
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google" {
  alias   = "hub"
  project = var.hub_project_id
  region  = var.region
}

data "terraform_remote_state" "hub" {
  backend = "gcs"
  config = {
    bucket = var.hub_state_bucket
    prefix = var.hub_state_prefix
  }
}

module "project" {
  source          = "../../modules/project"
  create_project  = var.create_project
  project_name    = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account
  labels          = var.labels
  enable_apis     = var.enable_apis
}

module "network_spoke" {
  source       = "../../modules/network-spoke"
  project_id   = var.project_id
  network_name = var.spoke_network_name
  routing_mode = var.routing_mode
  description  = var.spoke_network_description
  subnets      = var.spoke_subnets

  depends_on = [module.project]
}

module "ncc_spoke" {
  source              = "../../modules/ncc"
  project_id          = var.project_id
  create_spoke        = var.use_ncc
  spoke_name          = var.ncc_spoke_name
  spoke_location      = "global"
  spoke_description   = var.ncc_spoke_description
  hub_self_link       = data.terraform_remote_state.hub.outputs.ncc_hub_self_link
  linked_vpc_network  = module.network_spoke.network_self_link
  labels              = var.labels

  depends_on = [module.network_spoke]
}

resource "google_compute_network_peering" "hub_to_spoke" {
  count                  = var.use_ncc ? 0 : 1
  name                   = "${var.spoke_network_name}-to-hub"
  project                = var.project_id
  network                = module.network_spoke.network_self_link
  peer_network           = data.terraform_remote_state.hub.outputs.hub_network_self_link
  export_custom_routes   = true
  import_custom_routes   = true

  depends_on = [module.network_spoke]
}

resource "google_compute_network_peering" "spoke_to_hub" {
  count                = var.use_ncc ? 0 : 1
  name                 = "hub-to-${var.spoke_network_name}"
  project              = var.hub_project_id
  network              = data.terraform_remote_state.hub.outputs.hub_network_self_link
  peer_network         = module.network_spoke.network_self_link
  export_custom_routes = true
  import_custom_routes = true

  provider = google.hub
}

module "firewall" {
  source     = "../../modules/firewall"
  project_id = var.project_id
  network    = module.network_spoke.network_self_link
  rules      = var.firewall_rules

  depends_on = [module.network_spoke]
}

module "gke_sa" {
  source       = "../../modules/service-accounts"
  project_id   = var.project_id
  account_id   = var.gke_config.node_service_account_id
  display_name = "GKE node service account"
  description  = "Service account for GKE nodes"
  roles        = var.gke_config.node_service_account_roles
}

module "vm_sa" {
  source       = "../../modules/service-accounts"
  project_id   = var.project_id
  account_id   = var.vm_config.service_account_id
  display_name = "VM service account"
  description  = "Service account for VM"
  roles        = var.vm_config.service_account_roles
}

module "gke" {
  source                       = "../../modules/gke-basic"
  project_id                   = var.project_id
  cluster_name                 = var.gke_config.cluster_name
  location                     = var.gke_config.location
  network                      = module.network_spoke.network_self_link
  subnetwork                   = module.network_spoke.subnet_self_links[var.gke_config.subnet_name]
  pod_secondary_range_name     = var.gke_config.pod_secondary_range_name
  service_secondary_range_name = var.gke_config.service_secondary_range_name
  master_ipv4_cidr_block       = var.gke_config.master_ipv4_cidr_block
  release_channel              = var.gke_config.release_channel
  master_authorized_networks   = var.gke_config.master_authorized_networks
  node_pool_name               = var.gke_config.node_pool_name
  node_count                   = var.gke_config.node_count
  machine_type                 = var.gke_config.machine_type
  disk_size_gb                 = var.gke_config.disk_size_gb
  disk_type                    = var.gke_config.disk_type
  node_service_account         = module.gke_sa.email
  node_tags                    = var.gke_config.node_tags
  node_labels                  = var.gke_config.node_labels
  enable_autoscaling           = var.gke_config.enable_autoscaling
  autoscaling_min_node_count   = var.gke_config.autoscaling_min_node_count
  autoscaling_max_node_count   = var.gke_config.autoscaling_max_node_count
  labels                       = var.labels

  depends_on = [module.network_spoke, module.firewall, module.ncc_spoke]
}

module "vm" {
  source                = "../../modules/compute-vm"
  project_id            = var.project_id
  instance_name         = var.vm_config.instance_name
  zone                  = var.vm_config.zone
  machine_type          = var.vm_config.machine_type
  boot_image            = var.vm_config.boot_image
  boot_disk_size_gb     = var.vm_config.boot_disk_size_gb
  boot_disk_type        = var.vm_config.boot_disk_type
  network               = module.network_spoke.network_self_link
  subnetwork            = module.network_spoke.subnet_self_links[var.vm_config.subnet_name]
  assign_public_ip      = var.vm_config.assign_public_ip
  service_account_email = module.vm_sa.email
  startup_script        = var.vm_config.startup_script
  labels                = var.labels

  depends_on = [module.network_spoke, module.firewall]
}
