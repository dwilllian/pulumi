create_project   = true
project_name     = "gcp-dev"
project_id       = "gcp-dev-123456"
hub_project_id   = "gcp-hub-123456"
org_id           = "123456789012"
billing_account  = "000000-000000-000000"
region           = "us-central1"
routing_mode     = "GLOBAL"

spoke_network_name        = "dev-vpc"
spoke_network_description = "Dev spoke VPC"

spoke_subnets = [
  {
    name                     = "dev-subnet-us-central1"
    region                   = "us-central1"
    ip_cidr_range            = "10.10.0.0/24"
    private_ip_google_access = true
    secondary_ranges = [
      {
        range_name    = "dev-pods"
        ip_cidr_range = "10.10.16.0/20"
      },
      {
        range_name    = "dev-services"
        ip_cidr_range = "10.10.32.0/20"
      }
    ]
  }
]

use_ncc              = true
ncc_spoke_name       = "dev-spoke"
ncc_spoke_description = "Dev NCC spoke"

hub_state_bucket = "gcp-hubspoke-tfstate-01"
hub_state_prefix = "envs/hub"

firewall_rules = [
  {
    name                    = "dev-allow-iap-ssh"
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
    name                    = "dev-allow-hub"
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
    name                    = "dev-deny-all-ingress"
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

gke_config = {
  cluster_name                 = "dev-gke"
  location                     = "us-central1"
  subnet_name                  = "dev-subnet-us-central1"
  pod_secondary_range_name     = "dev-pods"
  service_secondary_range_name = "dev-services"
  master_ipv4_cidr_block       = "172.16.0.0/28"
  release_channel              = "REGULAR"
  master_authorized_networks = [
    {
      cidr_block   = "10.0.0.0/24"
      display_name = "hub"
    }
  ]
  node_pool_name             = "primary"
  node_count                 = 1
  machine_type               = "e2-medium"
  disk_size_gb               = 50
  disk_type                  = "pd-standard"
  node_service_account_id    = "gke-nodes"
  node_service_account_roles = ["roles/logging.logWriter", "roles/monitoring.metricWriter"]
  node_tags                  = ["gke-nodes"]
  node_labels = {
    env = "dev"
  }
  enable_autoscaling         = false
  autoscaling_min_node_count = 1
  autoscaling_max_node_count = 3
}

vm_config = {
  instance_name         = "dev-vm"
  zone                  = "us-central1-a"
  subnet_name           = "dev-subnet-us-central1"
  machine_type          = "e2-medium"
  boot_image            = "projects/debian-cloud/global/images/family/debian-12"
  boot_disk_size_gb     = 20
  boot_disk_type        = "pd-balanced"
  assign_public_ip      = false
  service_account_id    = "dev-vm-sa"
  service_account_roles = ["roles/logging.logWriter", "roles/monitoring.metricWriter"]
  startup_script        = ""
}

labels = {
  env         = "dev"
  owner       = "platform-team"
  cost_center = "cc1234"
  application = "hub-spoke"
}

enable_apis = [
  "serviceusage.googleapis.com",
  "compute.googleapis.com",
  "iam.googleapis.com",
  "container.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "networkconnectivity.googleapis.com",
  "servicenetworking.googleapis.com",
  "logging.googleapis.com",
  "monitoring.googleapis.com"
]
