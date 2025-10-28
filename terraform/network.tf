# A Rede Virtual (VCN)
resource "oci_core_vcn" "main_vcn" {
  compartment_id = data.oci_identity_compartment.main.id
  cidr_block     = "10.0.0.0/16"
  display_name   = "main-vcn"
}

# Gateway para a Internet
resource "oci_core_internet_gateway" "main_igw" {
  compartment_id = data.oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "main-igw"
}

# Tabela de Rota (para enviar tráfego da internet para o gateway)
resource "oci_core_route_table" "main_rt" {
  compartment_id = data.oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main_vcn.id
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.main_igw.id
  }
}

# Regras de Firewall
resource "oci_core_security_list" "main_sl" {
  compartment_id = data.oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "main-sl"

  ingress_security_rules { # Entrada
    protocol  = "6" // TCP
    source    = "0.0.0.0/0"
    stateless = false
    tcp_options { 
            min = 22 
            max = 22 
        }
    description = "Permite SSH"
  }
  ingress_security_rules {
    protocol  = "6" // TCP
    source    = "0.0.0.0/0"
    stateless = false
    tcp_options { 
            min = 80
            max = 80 
        }
    description = "Permite HTTP (para o LB -> Nginx)"
  }
  ingress_security_rules {
    protocol  = "6" // TCP
    source    = "0.0.0.0/0"
    stateless = false
    tcp_options { 
            min = 443
            max = 443 
        }
    description = "Permite HTTPS (para o LB)"
  }
  
  egress_security_rules { # Saída
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless   = false
  }
}

# A Subnet Pública (onde a VM e o LB vão viver)
resource "oci_core_subnet" "main_subnet" {
  compartment_id      = data.oci_identity_compartment.main.id
  vcn_id              = oci_core_vcn.main_vcn.id
  cidr_block          = "10.0.1.0/24"
  display_name        = "main-public-subnet"
  route_table_id      = oci_core_route_table.main_rt.id
  security_list_ids   = [oci_core_security_list.main_sl.id]
  dhcp_options_id     = oci_core_vcn.main_vcn.default_dhcp_options_id
}