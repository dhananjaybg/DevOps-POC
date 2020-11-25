variable "cluster_name" { default = "cvs2-cluster-gcp" }
variable "project_name" { default = "cvs2-project-gcp" }


variable "atlas_org_id" { default = "XXXXXXXXXXXXX" }
variable "atlas_public_key" { default = "XXXXXX" }
variable "atlas_private_key" { default = "XXXXXXXXXXXXXXXXXXX" }

variable "GCP_PROJECT_ID" { default = "atlas-peered-294702" }
variable "public_subnet_cidr" { default = "10.15.0.0/16" }
variable "vpc_name" { default = "cvs2-vpc" }
variable "peer_connection_name" { default = "cvs2-pcx"}
  

variable "database_username" { default = "main_user" }
variable "database_user_password" { default = "muser" }
variable "whitelistip" { default = "98.110.167.37" }

variable "mongodb_params" { default = " --collection qadb --file  samp_qa.json "}
#variable "mongodb_params" { default = "  --ssl --username db-acc-rw-user --password db-acc-rw-user --collection qadb --file  samp_qa.json "}

