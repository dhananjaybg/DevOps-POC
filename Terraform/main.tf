# Configure the MongoDB Atlas Provider EDIT 7 
provider "mongodbatlas" {
  public_key    = var.atlas_public_key
  private_key   = var.atlas_private_key 
}
provider "google" {
  project     = var.GCP_PROJECT_ID
  region      = "us-central1"
  credentials = file("atlas-peered-aa005619c5fa.json")
}

# Create a Project
resource "mongodbatlas_project" "mongo_project" {
    name    = var.cluster_name
    org_id  = var.atlas_org_id
}

resource "mongodbatlas_project_ip_whitelist" "test11" {
  project_id = mongodbatlas_project.mongo_project.id
  cidr_block = var.public_subnet_cidr
  comment    = "cidr block for tf acc testing"
}

resource "mongodbatlas_encryption_at_rest" "mongo_encrypt" {
  project_id = mongodbatlas_project.mongo_project.id
  google_cloud_kms = {
      enabled                   = true
      service_account_key       = file("atlas-peered-aa005619c5fa.json")
      key_version_resource_id   = "projects/atlas-peered-294702/locations/global/keyRings/cvs-poc-ring/cryptoKeys/Keyfor-AtlasCluster-Peer2/cryptoKeyVersions/1"
    }
}

# Container example provided but not always required, 
# see network_container documentation for details. 
resource "mongodbatlas_network_container" "peer-container" {
  project_id       = mongodbatlas_project.mongo_project.id
  atlas_cidr_block = "192.168.0.0/16"
  provider_name    = "GCP"
}

# Create the peering connection request
resource "mongodbatlas_network_peering" "test" {
  project_id     = mongodbatlas_project.mongo_project.id
  container_id   = mongodbatlas_network_container.peer-container.container_id
  provider_name  = "GCP"
  gcp_project_id = var.GCP_PROJECT_ID
  network_name   = var.vpc_name
}

# the following assumes a GCP provider is configured
data "google_compute_network" "default" {
  name  = var.vpc_name
}

# Create the GCP peer
resource "google_compute_network_peering" "peering" {
  name         =  var.peer_connection_name
  network      = data.google_compute_network.default.self_link
  peer_network = "https://www.googleapis.com/compute/v1/projects/${mongodbatlas_network_peering.test.atlas_gcp_project_id}/global/networks/${mongodbatlas_network_peering.test.atlas_vpc_name}"
}



#   Create a Cluster in 2 Regions
resource "mongodbatlas_cluster" "multiregion_cluster" {
    project_id                    = mongodbatlas_project.mongo_project.id
    name                          = var.project_name
    num_shards                    = 1

    replication_factor            = 3
    provider_backup_enabled       = true
    auto_scaling_disk_gb_enabled  = true
    mongo_db_major_version        = "4.4"
    #encryption_at_rest_provider   = "GCP"

    //Provider Settings "block"
    provider_name                 = "GCP"
    disk_size_gb                  = 40
    provider_instance_size_name   = "M10"
    provider_region_name          = "US_EAST_4"

    depends_on = [mongodbatlas_encryption_at_rest.mongo_encrypt,google_compute_network_peering.peering]
    #depends_on = [google_compute_network_peering.peering]
} 

#
# Create a Database User
#
resource "mongodbatlas_database_user" "test-user" {
  username 		          = var.database_username
  password 	 	          = var.database_user_password
  project_id            = mongodbatlas_project.mongo_project.id
  auth_database_name	 	= "admin"
  roles {
    role_name     	    = "readWriteAnyDatabase"
    database_name       = "admin"
  }
}



locals {
  cmd_ls = replace(mongodbatlas_cluster.multiregion_cluster.srv_address,"////","//main_user:muser@") 
  cmd2  = format( "mongoimport --uri %s  --collection qadb2 --file  samp_qa.json",local.cmd_ls)  
}

output "outvals" {
  value = local.cmd2
}

output "atlasclusterstring" {
    value = mongodbatlas_cluster.multiregion_cluster.connection_strings
}
#for specific string 
output "srv_string" {
    value = lookup( mongodbatlas_cluster.multiregion_cluster.connection_strings[0],"standard_srv","hencedeafault")
}

output "Message_to_Requester" {
  value = "To import Data Use this "
}
output "mongo_import_cmd" {
    value = format ("mongoimport --uri %s!  --collection qadb2 --file  samp_qa.json",lookup( mongodbatlas_cluster.multiregion_cluster.connection_strings[0],"standard_srv","hencedeafault"))
}

#
# Create an IP Whitelist
#
resource "mongodbatlas_project_ip_whitelist" "test" {
  project_id    = mongodbatlas_project.mongo_project.id
  ip_address    = "98.110.167.37"
  #ip_address    = "0.0.0.0"
  //var.whitelistip
  comment       = "Added with Terraform"

  provisioner "local-exec" {
    #command = "open WFH, '>completed.txt' and print WFH scalar localtime"
    #interpreter = ["perl", "-e"]
     command = local.cmd2
    #command = "mongoimport --uri mongodb+srv://main_user:muser@terra-cluster.fjmdo.mongodb.net  --collection qadb34 --file  samp_qa.json"
  }
}

