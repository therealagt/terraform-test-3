output "app_vm_ip" {
  value = google_compute_instance.app_vm.network_interface[0].network_ip
}

output "app_vm_self_link" {
  value = google_compute_instance.app_vm.self_link
}