output "vm_public_ip" {
  description = "IP Público para acessar a VM via SSH"
  value       = oci_core_instance.main_vm.public_ip
}

output "load_balancer_ip" {
  description = "IP Público do Load Balancer (aponte seu DNS para cá)"
  value       = oci_load_balancer_load_balancer.main_lb.ip_addresses[0].ip_address
}

# output "db_connection_string_low" {
#   description = "Connection string 'LOW' para o Autonomous DB"
#   value       = oci_database_autonomous_database.main_db.connection_strings[0].all_connection_strings["LOW"]
#   sensitive   = true
# }