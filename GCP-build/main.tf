provider "google" {
  project     = var.GCP_PROJECT_ID
  region      = "us-central1"
  credentials = file("/Users/dghevde/gcp-creds/atlas-peered-aa005619c5fa.json")
}

resource "google_compute_network" "vpc" {
  name                    = "cvs2-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "default" {
 name    = "cvs2-fw"
 network = "cvs2-vpc"
 allow {
   protocol = "tcp"
   ports    = [ "22", "27017", "3000" ]
 }
 depends_on = [google_compute_network.vpc]
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "cvs2-pub-net"
  ip_cidr_range = "10.15.0.0/16"
  network       = google_compute_network.vpc.name
  region        = "us-central1"
  #private_ip_google_access = "false"
}

resource "google_compute_subnetwork" "private_subnet" {
  name          =  "cvs2-pri-net"
  ip_cidr_range = "10.16.0.0/16"
  network      = google_compute_network.vpc.name
  region        = "us-central1"
  #private_ip_google_access = "true"
}

resource "google_compute_instance" "default" {
  name         = "cvs2-ssh-mongoshell"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  network_interface {
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet.name
    access_config {
      // Ephemeral IP
    }
  }
  ##metadata_startup_script = "echo hi > /djtest.txt"
  metadata_startup_script = file("loadmongo-shell-2.sh")
  ##metadata {
  ##    startup-script = <<SCRIPT
  ##    sudo apt update
  ##    cd ~
  ##    wget "https://downloads.mongodb.org/linux/mongodb-shell-linux-x86_64-ubuntu2004-4.4.1.tgz"
  ##    chmod 777 mongodb-shell-linux-x86_64-ubuntu2004-4.4.1.tgz
  ##    tar -xvf mongodb-shell-linux-x86_64-ubuntu2004-4.4.1.tgz
  ##    SCRIPT
  ##}
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
 depends_on = [google_compute_firewall.default]
}
