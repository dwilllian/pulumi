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
  source             = "../../modules/ncc"
  project_id         = var.project_id
  create_spoke       = var.use_ncc
  spoke_name         = var.ncc_spoke_name
  spoke_location     = "global"
  spoke_description  = var.ncc_spoke_description
  hub_self_link      = data.terraform_remote_state.hub.outputs.ncc_hub_self_link
  linked_vpc_network = module.network_spoke.network_self_link
  labels             = var.labels

  depends_on = [module.network_spoke]
}

resource "google_compute_network_peering" "hub_to_spoke" {
  count                = var.use_ncc ? 0 : 1
  name                 = "${var.spoke_network_name}-to-hub"
  project              = var.project_id
  network              = module.network_spoke.network_self_link
  peer_network         = data.terraform_remote_state.hub.outputs.hub_network_self_link
  export_custom_routes = true
  import_custom_routes = true

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
