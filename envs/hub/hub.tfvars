create_project        = true
project_name          = "gcp-hub"
project_id            = "gcp-hub-123456"
org_id                = "123456789012"
billing_account       = "000000-000000-000000"
region                = "us-central1"
routing_mode          = "GLOBAL"

hub_network_name        = "hub-vpc"
hub_network_description = "Hub VPC for shared services"

hub_subnets = [
  {
    name                     = "hub-subnet-us-central1"
    region                   = "us-central1"
    ip_cidr_range            = "10.0.0.0/24"
    private_ip_google_access = true
    secondary_ranges         = []
  }
]

enable_nat              = true
nat_router_name         = "hub-router"
nat_name                = "hub-nat"
nat_ip_allocate_option  = "AUTO_ONLY"
nat_source_subnet_ranges = "ALL_SUBNETWORKS_ALL_IP_RANGES"

nat_subnetworks = []

use_ncc             = true
ncc_hub_name        = "hub-ncc"
ncc_hub_description = "NCC hub for hub-spoke connectivity"

firewall_rules = [
  {
    name                    = "hub-allow-iap-ssh"
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
    name                    = "hub-allow-spoke"
    description             = "Allow spoke CIDRs to hub"
    direction               = "INGRESS"
    priority                = 1100
    source_ranges           = ["10.10.0.0/16", "10.20.0.0/16", "10.30.0.0/16"]
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
    name                    = "hub-deny-all-ingress"
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
  env         = "hub"
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
