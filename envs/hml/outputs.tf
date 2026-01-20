output "project_id" {
  value       = var.project_id
  description = "HML project ID."
}

output "spoke_network_self_link" {
  value       = module.network_spoke.network_self_link
  description = "HML spoke network self link."
}

output "spoke_subnet_self_links" {
  value       = module.network_spoke.subnet_self_links
  description = "HML spoke subnet self links."
}
