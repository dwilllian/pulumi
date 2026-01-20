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

variable "hub_network_name" {
  type        = string
  description = "Hub VPC name."
}

variable "hub_network_description" {
  type        = string
  description = "Hub VPC description."
}

variable "hub_subnets" {
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
  description = "Hub subnets."
}

variable "enable_nat" {
  type        = bool
  description = "Enable Cloud NAT."
}

variable "nat_router_name" {
  type        = string
  description = "Cloud Router name."
}

variable "nat_name" {
  type        = string
  description = "Cloud NAT name."
}

variable "nat_ip_allocate_option" {
  type        = string
  description = "NAT IP allocation option."
}

variable "nat_source_subnet_ranges" {
  type        = string
  description = "NAT source subnet ranges."
}

variable "nat_subnetworks" {
  type = list(object({
    name                    = string
    source_ip_ranges_to_nat = list(string)
  }))
  description = "Subnetwork NAT configuration."
}

variable "use_ncc" {
  type        = bool
  description = "Use NCC for hub-spoke connectivity."
}

variable "ncc_hub_name" {
  type        = string
  description = "NCC hub name."
}

variable "ncc_hub_description" {
  type        = string
  description = "NCC hub description."
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

variable "labels" {
  type        = map(string)
  description = "Common labels."
}

variable "enable_apis" {
  type        = list(string)
  description = "List of APIs to enable."
}
