variable "project_id" {
  type        = string
  description = "Project ID."
}

variable "network" {
  type        = string
  description = "Network self link or name."
}

variable "rules" {
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

  validation {
    condition = alltrue([
      for rule in var.rules : !(length(rule.target_tags) > 0 && length(rule.target_service_accounts) > 0)
    ])
    error_message = "Firewall rule cannot set both target_tags and target_service_accounts."
  }
}
