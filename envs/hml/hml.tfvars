create_project   = true
project_name     = "gcp-hml"
project_id       = "gcp-hml-123456"
hub_project_id   = "gcp-hub-123456"
org_id           = "123456789012"
billing_account  = "000000-000000-000000"
region           = "us-central1"
routing_mode     = "GLOBAL"

spoke_network_name        = "hml-vpc"
spoke_network_description = "HML spoke VPC"

spoke_subnets = [
  {
    name                     = "hml-subnet-us-central1"
    region                   = "us-central1"
    ip_cidr_range            = "10.20.0.0/24"
    private_ip_google_access = true
    secondary_ranges         = []
  }
]

use_ncc               = true
ncc_spoke_name        = "hml-spoke"
ncc_spoke_description = "HML NCC spoke"

hub_state_bucket = "gcp-hubspoke-tfstate-01"
hub_state_prefix = "envs/hub"

firewall_rules = [
  {
    name                    = "hml-allow-iap-ssh"
    description             = "Allow SSH from IAP"
    direction               = "INGRESS"
    priority                = 1000
    source_ranges           = ["35.235.240.0/20"]
    destination_ranges      = []
    target_tags             = ["allow-iap-ssh"]
    target_service_accounts = []
    allow = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]
    deny = []
  },
  {
    name                    = "hml-allow-hub"
    description             = "Allow hub CIDRs"
    direction               = "INGRESS"
    priority                = 1100
    source_ranges           = ["10.0.0.0/24"]
    destination_ranges      = []
    target_tags             = []
    target_service_accounts = []
    allow = [
      {
        protocol = "all"
        ports    = []
      }
    ]
    deny = []
  },
  {
    name                    = "hml-deny-all-ingress"
    description             = "Default deny ingress"
    direction               = "INGRESS"
    priority                = 65534
    source_ranges           = ["0.0.0.0/0"]
    destination_ranges      = []
    target_tags             = []
    target_service_accounts = []
    allow = []
    deny = [
      {
        protocol = "all"
        ports    = []
      }
    ]
  }
]

labels = {
  env         = "hml"
  owner       = "platform-team"
  cost_center = "cc1234"
  application = "hub-spoke"
}

enable_apis = [
  "serviceusage.googleapis.com",
  "compute.googleapis.com",
  "iam.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "networkconnectivity.googleapis.com",
  "servicenetworking.googleapis.com",
  "logging.googleapis.com",
  "monitoring.googleapis.com"
]
