terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "7.23.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# Pega informações do compartimento "root" para usar em outros recursos
data "oci_identity_compartment" "main" {
  id = var.tenancy_ocid
}

# Pega a lista de Availability Domains (ADs) da sua região.
# O Free Tier AMPERE só funciona em alguns ADs, geralmente o primeiro.
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}