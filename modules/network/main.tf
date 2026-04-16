resource "google_compute_network" "my_vpc" {
  name = "my-vpc"
  auto_create_subnetworks = false
}

# Public subnet for load balancer
resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.my_vpc.id
  region        = var.region
}

# Private subnet for instances
resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  network       = google_compute_network.my_vpc.id
  region        = var.region
  private_ip_google_access = true
}

# Cloud Router for NAT
resource "google_compute_router" "router" {
  name    = "my-router"
  region  = var.region
  network = google_compute_network.my_vpc.id
}

# Cloud NAT
resource "google_compute_router_nat" "nat" {
    name                               = "my-nat"
    router                             = google_compute_router.router.name
    region                             = var.region
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  
    subnetwork {
      name = google_compute_subnetwork.private_subnet.id
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
}

# Allow HTTP/HTTPS to public subnet / Load Balancer
resource "google_compute_firewall" "allow_lb_http_https" {
  name    = "allow-lb"
  network = google_compute_network.my_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
  target_tags = ["app"]
}

# Allow private subnet to reach DB
resource "google_compute_firewall" "allow_private_to_db" {
  name    = "allow-private-to-db"
  network = google_compute_network.my_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_tags = ["app"]
  target_tags = ["db"]
}

# Allow IAP SSH
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.my_vpc.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}