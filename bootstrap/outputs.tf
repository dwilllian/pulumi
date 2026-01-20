output "state_bucket_name" {
  value       = google_storage_bucket.terraform_state.name
  description = "Terraform state bucket name."
}

output "project_id" {
  value       = module.project.project_id
  description = "Project ID."
}
