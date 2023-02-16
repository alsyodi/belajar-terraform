provider "google" {
    project = "aldisypu-labs"
    region = "asia-southeast2"
    credentials = var.google_credentials
}

variable "google_credentials" {
    description = "credential dari service account saya"
}
variable "subnet_ip_cidr_range" {
    description = "ip range untuk semua subnet"
    type = list(object({
        range = string
        name = string
    }))
}

variable "subnet_secondary_ip_cidr_range" {
    description = "secondary ip range untuk dev environmen"
}

variable "network_name" {
    description = "nama network kita"
}


resource "google_compute_network" "development_network" {
    name = var.network_name
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev_subnet_01" {
    name = var.subnet_ip_cidr_range[0].name
    ip_cidr_range = var.subnet_ip_cidr_range[0].range
    network = google_compute_network.development_network.id
    region = "asia-southeast2"
    secondary_ip_range {
        range_name = "secondary-range-01"
        ip_cidr_range = var.subnet_secondary_ip_cidr_range
    }
}

resource "google_compute_subnetwork" "dev_subnet_02" {
    name = var.subnet_ip_cidr_range[1].name
    ip_cidr_range = var.subnet_ip_cidr_range[1].range
    network = google_compute_network.development_network.id
    region = "asia-southeast2"
}

data "google_compute_network" "existing_default_network" {
    name = "default"
}

resource "google_compute_subnetwork" "dev_subnet_02" {
    name = "dev-subnet-02"
    ip_cidr_range = "10.110.0.0/16"
    network = data.google_compute_network.existing_default_network.id
    region = "asia-southeast2"
}

output "development_network_id" {
    value = google_compute_network.development_network.id
}

output "get_subnet_01_gateway" {
    value = google_compute_subnetwork.dev_subnet_01.gateway_address
}