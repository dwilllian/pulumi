variable "project_id" {
  type        = string
  description = "Project ID where the spoke network will be created."
}

variable "network_name" {
  type        = string
  description = "Spoke VPC name."
}

variable "routing_mode" {
  type        = string
  description = "Routing mode for the spoke network."
  default     = "GLOBAL"

  validation {
    condition     = contains(["GLOBAL", "REGIONAL"], var.routing_mode)
    error_message = "routing_mode must be GLOBAL or REGIONAL."
  }
}

variable "description" {
  type        = string
  description = "Network description."
  default     = null
}

variable "subnets" {
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
  description = "List of spoke subnets."
}
