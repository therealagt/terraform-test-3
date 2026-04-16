output "db_ip" {
  value = google_compute_instance.db_vm.network_interface[0].network_ip
}

output "db_instance" {
  value = google_compute_instance.db_vm
}