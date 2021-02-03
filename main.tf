module "mirrored-vpc" {
  source      = "./modules/terraform-gcp-vpc"
  credentials = "credentials.json"
  gcp_project = "calcium-vial-280707"
  region      = "us-central1"
  name        = "mirrored"
  ip_ranges = {
    public          = ["10.10.1.0/24", "10.10.2.0/24"]
    private_primary = "10.10.0.0/24"
  }

}

module "collector-vpc" {
  source      = "./modules/terraform-gcp-vpc"
  credentials = "credentials.json"
  gcp_project = "calcium-vial-280707"
  region      = "us-central1"
  name        = "collector"
  ip_ranges = {
    public          = ["10.10.4.0/24", "10.10.5.0/24"]
    private_primary = "10.10.3.0/24"
  }
}



module "vpc_peering" {
  source        = "./modules/terraform-gcp-vpc-peering"
  credentials   = "credentials.json"
  gcp_project   = "calcium-vial-280707"
  region        = "us-central1"
  prefix        = "peering"
  local_network = "projects/calcium-vial-280707/global/networks/mirrored-vpc"
  peer_network  = "projects/calcium-vial-280707/global/networks/collector-vpc"

}