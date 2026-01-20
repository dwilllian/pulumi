variable "enable_nat" {
  type        = bool
  description = "Enable Cloud NAT."
  default     = false
}

variable "project_id" {
  type        = string
  description = "Project ID."
}

variable "region" {
  type        = string
  description = "Region."
}

variable "network" {
  type        = string
  description = "Network self link."
}

variable "router_name" {
  type        = string
  description = "Cloud Router name."
  default     = null
}

variable "nat_name" {
  type        = string
  description = "Cloud NAT name."
  default     = null
}

variable "nat_ip_allocate_option" {
  type        = string
  description = "NAT IP allocation option."
  default     = "AUTO_ONLY"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type        = string
  description = "NAT source subnet ranges."
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "min_ports_per_vm" {
  type        = number
  description = "Minimum ports per VM."
  default     = null
}

variable "udp_idle_timeout_sec" {
  type        = number
  description = "UDP idle timeout."
  default     = null
}

variable "icmp_idle_timeout_sec" {
  type        = number
  description = "ICMP idle timeout."
  default     = null
}

variable "tcp_established_idle_timeout_sec" {
  type        = number
  description = "TCP established idle timeout."
  default     = null
}

variable "tcp_transitory_idle_timeout_sec" {
  type        = number
  description = "TCP transitory idle timeout."
  default     = null
}

variable "enable_endpoint_independent_mapping" {
  type        = bool
  description = "Enable endpoint independent mapping."
  default     = true
}

variable "subnetworks" {
  type = list(object({
    name                    = string
    source_ip_ranges_to_nat = list(string)
  }))
  description = "Subnetwork NAT configuration."
  default     = []
}
