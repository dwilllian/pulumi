create_project           = true
project_name             = "gcp-hub-spoke-bootstrap"
project_id               = "gcp-hubspoke-01"
org_id                   = "123456789012"
billing_account          = "000000-000000-000000"
region                   = "us-central1"
state_bucket_name        = "gcp-hubspoke-tfstate-01"
state_bucket_location    = "US"
state_bucket_retention_days = 90
labels = {
  env         = "shared"
  owner       = "platform-team"
  cost_center = "cc1234"
  application = "hub-spoke"
}
