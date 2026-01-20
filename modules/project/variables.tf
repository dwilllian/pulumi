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
}

variable "org_id" {
  type        = string
  description = "Organization ID."
}

variable "billing_account" {
  type        = string
  description = "Billing account ID."
}

variable "labels" {
  type        = map(string)
  description = "Project labels."
  default     = {}
}

variable "enable_apis" {
  type        = list(string)
  description = "List of APIs to enable."
  default     = []
}
