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

module "network_hub" {
  source       = "../../modules/network-hub"
  project_id   = var.project_id
  network_name = var.hub_network_name
  routing_mode = var.routing_mode
  description  = var.hub_network_description
  subnets      = var.hub_subnets

  depends_on = [module.project]
}

module "nat" {
  source                         = "../../modules/nat"
  enable_nat                     = var.enable_nat
  project_id                     = var.project_id
  region                         = var.region
  network                        = module.network_hub.network_self_link
  router_name                    = var.nat_router_name
  nat_name                       = var.nat_name
  nat_ip_allocate_option         = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.nat_source_subnet_ranges
  subnetworks                    = var.nat_subnetworks

  depends_on = [module.network_hub]
}

module "ncc_hub" {
  source         = "../../modules/ncc"
  project_id     = var.project_id
  create_hub     = var.use_ncc
  hub_name       = var.ncc_hub_name
  hub_description = var.ncc_hub_description
  labels         = var.labels

  depends_on = [module.network_hub]
}

module "firewall" {
  source     = "../../modules/firewall"
  project_id = var.project_id
  network    = module.network_hub.network_self_link
  rules      = var.firewall_rules

  depends_on = [module.network_hub]
}
