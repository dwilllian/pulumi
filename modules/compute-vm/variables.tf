variable "project_id" {
  type        = string
  description = "Project ID."
}

variable "instance_name" {
  type        = string
  description = "Instance name."
}

variable "zone" {
  type        = string
  description = "Instance zone."
}

variable "machine_type" {
  type        = string
  description = "Machine type."
}

variable "boot_image" {
  type        = string
  description = "Boot image."
}

variable "boot_disk_size_gb" {
  type        = number
  description = "Boot disk size in GB."
}

variable "boot_disk_type" {
  type        = string
  description = "Boot disk type."
}

variable "network" {
  type        = string
  description = "Network self link."
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork self link."
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign public IP."
  default     = false
}

variable "service_account_email" {
  type        = string
  description = "Service account email."
}

variable "service_account_scopes" {
  type        = list(string)
  description = "Service account scopes."
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "startup_script" {
  type        = string
  description = "Startup script."
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "Labels."
  default     = {}
}
