variable "create_project" {
  type        = bool
  description = "Whether to create the project."
}

variable "project_name" {
  type        = string
  description = "Project display name."
}

variable "project_id" {
  type        = string
  description = "Project ID."

  validation {
    condition     = length(var.project_id) >= 6 && length(var.project_id) <= 30
    error_message = "project_id must be 6-30 characters."
  }
}

variable "hub_project_id" {
  type        = string
  description = "Hub project ID (for peering fallback)."
}

variable "org_id" {
  type        = string
  description = "Organization ID."
}

variable "billing_account" {
  type        = string
  description = "Billing account ID."
}

variable "region" {
  type        = string
  description = "Default region."
}

variable "routing_mode" {
  type        = string
  description = "VPC routing mode."
}

variable "spoke_network_name" {
  type        = string
  description = "Spoke VPC name."
}

variable "spoke_network_description" {
  type        = string
  description = "Spoke VPC description."
}

variable "spoke_subnets" {
  type = list(object({
    name                     = string
    region                   = string
    ip_cidr_range            = string
    private_ip_google_access = bool
    secondary_ranges = list(object({
      range_name    = string
      ip_cidr_range = string
    }))
  }))
  description = "Spoke subnets."
}

variable "use_ncc" {
  type        = bool
  description = "Use NCC for hub-spoke connectivity."
}

variable "ncc_spoke_name" {
  type        = string
  description = "NCC spoke name."
}

variable "ncc_spoke_description" {
  type        = string
  description = "NCC spoke description."
}

variable "hub_state_bucket" {
  type        = string
  description = "GCS bucket for hub remote state."
}

variable "hub_state_prefix" {
  type        = string
  description = "Prefix for hub remote state."
}

variable "firewall_rules" {
  type = list(object({
    name                    = string
    description             = string
    direction               = string
    priority                = number
    source_ranges           = list(string)
    destination_ranges      = list(string)
    target_tags             = list(string)
    target_service_accounts = list(string)
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    deny = list(object({
      protocol = string
      ports    = list(string)
    }))
  }))
  description = "Firewall rules."
}

variable "gke_config" {
  type = object({
    cluster_name                 = string
    location                     = string
    subnet_name                  = string
    pod_secondary_range_name     = string
    service_secondary_range_name = string
    master_ipv4_cidr_block       = string
    release_channel              = string
    master_authorized_networks = list(object({
      cidr_block   = string
      display_name = string
    }))
    node_pool_name               = string
    node_count                   = number
    machine_type                 = string
    disk_size_gb                 = number
    disk_type                    = string
    node_service_account_id      = string
    node_service_account_roles   = list(string)
    node_tags                    = list(string)
    node_labels                  = map(string)
    enable_autoscaling           = bool
    autoscaling_min_node_count   = number
    autoscaling_max_node_count   = number
  })
  description = "GKE configuration."
}

variable "vm_config" {
  type = object({
    instance_name        = string
    zone                 = string
    subnet_name          = string
    machine_type         = string
    boot_image           = string
    boot_disk_size_gb    = number
    boot_disk_type       = string
    assign_public_ip     = bool
    service_account_id   = string
    service_account_roles = list(string)
    startup_script       = string
  })
  description = "VM configuration."
}

variable "labels" {
  type        = map(string)
  description = "Common labels."
}

variable "enable_apis" {
  type        = list(string)
  description = "List of APIs to enable."
}
