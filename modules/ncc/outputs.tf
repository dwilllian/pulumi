output "hub_self_link" {
  value       = try(google_network_connectivity_hub.this[0].self_link, null)
  description = "Hub self link."
}

output "spoke_self_link" {
  value       = try(google_network_connectivity_spoke.this[0].self_link, null)
  description = "Spoke self link."
}
