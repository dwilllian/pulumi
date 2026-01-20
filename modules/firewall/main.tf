locals {
  rule_map = { for rule in var.rules : rule.name => rule }
}

resource "google_compute_firewall" "rules" {
  for_each = local.rule_map

  name        = each.value.name
  project     = var.project_id
  network     = var.network
  description = each.value.description
  direction   = each.value.direction
  priority    = each.value.priority

  source_ranges      = length(each.value.source_ranges) > 0 ? each.value.source_ranges : null
  destination_ranges = length(each.value.destination_ranges) > 0 ? each.value.destination_ranges : null

  target_tags             = length(each.value.target_tags) > 0 ? each.value.target_tags : null
  target_service_accounts = length(each.value.target_service_accounts) > 0 ? each.value.target_service_accounts : null

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
}
