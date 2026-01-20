output "project_id" {
  value       = var.project_id
  description = "Hub project ID."
}

output "hub_network_self_link" {
  value       = module.network_hub.network_self_link
  description = "Hub VPC self link."
}

output "hub_subnet_self_links" {
  value       = module.network_hub.subnet_self_links
  description = "Hub subnet self links."
}

output "hub_subnet_cidrs" {
  value       = module.network_hub.subnet_cidrs
  description = "Hub subnet CIDRs."
}

output "ncc_hub_self_link" {
  value       = module.ncc_hub.hub_self_link
  description = "NCC hub self link."
}
