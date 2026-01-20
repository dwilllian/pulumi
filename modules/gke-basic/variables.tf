variable "project_id" {
  type        = string
  description = "Project ID."
}

variable "cluster_name" {
  type        = string
  description = "Cluster name."
}

variable "location" {
  type        = string
  description = "Cluster location (region or zone)."
}

variable "network" {
  type        = string
  description = "Network self link."
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork self link."
}

variable "pod_secondary_range_name" {
  type        = string
  description = "Secondary range name for pods."
}

variable "service_secondary_range_name" {
  type        = string
  description = "Secondary range name for services."
}

variable "enable_private_nodes" {
  type        = bool
  description = "Enable private nodes."
  default     = true
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Enable private endpoint."
  default     = false
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "Master IPv4 CIDR block."
}

variable "release_channel" {
  type        = string
  description = "GKE release channel."
  default     = "REGULAR"
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "Master authorized networks."
  default     = []
}

variable "logging_service" {
  type        = string
  description = "Logging service."
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  type        = string
  description = "Monitoring service."
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "node_pool_name" {
  type        = string
  description = "Node pool name."
}

variable "node_count" {
  type        = number
  description = "Node count."
}

variable "machine_type" {
  type        = string
  description = "Node machine type."
}

variable "disk_size_gb" {
  type        = number
  description = "Node disk size in GB."
}

variable "disk_type" {
  type        = string
  description = "Node disk type."
}

variable "node_service_account" {
  type        = string
  description = "Node service account email."
}

variable "node_tags" {
  type        = list(string)
  description = "Node network tags."
  default     = []
}

variable "node_labels" {
  type        = map(string)
  description = "Node labels."
  default     = {}
}

variable "node_oauth_scopes" {
  type        = list(string)
  description = "Node OAuth scopes."
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable node pool autoscaling."
  default     = false
}

variable "autoscaling_min_node_count" {
  type        = number
  description = "Autoscaling minimum node count."
  default     = null
}

variable "autoscaling_max_node_count" {
  type        = number
  description = "Autoscaling maximum node count."
  default     = null
}

variable "auto_upgrade" {
  type        = bool
  description = "Enable auto upgrade."
  default     = true
}

variable "auto_repair" {
  type        = bool
  description = "Enable auto repair."
  default     = true
}

variable "labels" {
  type        = map(string)
  description = "Labels."
  default     = {}
}
