output "lb_ip" {
  value = google_compute_global_address.app_lb_ip.address
}
