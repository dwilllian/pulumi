variable "project_id" {
  type        = string
  description = "Project ID."
}

variable "create_hub" {
  type        = bool
  description = "Whether to create an NCC hub."
  default     = false
}

variable "hub_name" {
  type        = string
  description = "Hub name."
  default     = null
}

variable "hub_description" {
  type        = string
  description = "Hub description."
  default     = null
}

variable "create_spoke" {
  type        = bool
  description = "Whether to create an NCC spoke."
  default     = false
}

variable "spoke_name" {
  type        = string
  description = "Spoke name."
  default     = null
}

variable "spoke_location" {
  type        = string
  description = "Spoke location."
  default     = "global"
}

variable "spoke_description" {
  type        = string
  description = "Spoke description."
  default     = null
}

variable "hub_self_link" {
  type        = string
  description = "Hub self link."
  default     = null
}

variable "linked_vpc_network" {
  type        = string
  description = "Linked VPC network URI."
  default     = null
}

variable "exclude_export_ranges" {
  type        = list(string)
  description = "CIDR ranges to exclude."
  default     = []
}

variable "include_export_ranges" {
  type        = list(string)
  description = "CIDR ranges to include."
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Resource labels."
  default     = {}
}
