variable "tenancy_ocid" { description = "OCID da sua Tenancy (Root Compartment)" }
variable "user_ocid" { description = "OCID do seu usuário" }
variable "fingerprint" { description = "Fingerprint da sua chave pública API" }
variable "private_key_path" { description = "Caminho para sua chave privada API" }
variable "region" { description = "Região da OCI (ex: us-ashburn-1)" }
variable "ssh_public_key" { description = "Sua chave SSH pública para acessar a VM" }
variable "db_admin_password" {
  description = "Senha para o admin do Autonomous DB"
  sensitive   = true
}