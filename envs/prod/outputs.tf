output "project_id" {
  value       = var.project_id
  description = "Prod project ID."
}

output "spoke_network_self_link" {
  value       = module.network_spoke.network_self_link
  description = "Prod spoke network self link."
}

output "spoke_subnet_self_links" {
  value       = module.network_spoke.subnet_self_links
  description = "Prod spoke subnet self links."
}
