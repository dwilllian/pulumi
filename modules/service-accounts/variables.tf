variable "project_id" {
  type        = string
  description = "Project ID."
}

variable "account_id" {
  type        = string
  description = "Service account ID."
}

variable "display_name" {
  type        = string
  description = "Service account display name."
}

variable "description" {
  type        = string
  description = "Service account description."
  default     = null
}

variable "roles" {
  type        = list(string)
  description = "List of IAM roles to bind."
  default     = []
}
