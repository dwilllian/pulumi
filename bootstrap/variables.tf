variable "create_project" {
  type        = bool
  description = "Whether to create the project."
  default     = false
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

variable "state_bucket_name" {
  type        = string
  description = "Terraform state bucket name."
}

variable "state_bucket_location" {
  type        = string
  description = "Terraform state bucket location."
}

variable "state_bucket_retention_days" {
  type        = number
  description = "Days to retain state object versions."
  default     = 90
}

variable "labels" {
  type        = map(string)
  description = "Common labels."
}

variable "enable_apis" {
  type        = list(string)
  description = "APIs to enable in bootstrap."
  default     = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billing.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com"
  ]
}
