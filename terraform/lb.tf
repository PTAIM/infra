resource "oci_load_balancer_load_balancer" "main_lb" {
  compartment_id = data.oci_identity_compartment.main.id
  display_name   = "main-lb"
  
  # Shape "Always Free"
  shape = "flexible"
  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }
  
  subnet_ids = [oci_core_subnet.main_subnet.id]
}

# O "Backend Set" (O grupo de servidores que recebem o tráfego)
resource "oci_load_balancer_backend_set" "main_lb_bset" {
  load_balancer_id = oci_load_balancer_load_balancer.main_lb.id
  name             = "vm-http-bset"
  policy           = "ROUND_ROBIN"

  # Health Check: O LB vai testar se o Nginx está vivo
  health_checker {
    protocol    = "HTTP"
    port        = 80  # Porta do Nginx na VM
    url_path    = "/" # O Nginx deve responder 200 na raiz
    return_code = 200
  }
}

# Adiciona a VM ao Backend Set
resource "oci_load_balancer_backend" "main_lb_backend" {
  load_balancer_id = oci_load_balancer_load_balancer.main_lb.id
  backendset_name  = oci_load_balancer_backend_set.main_lb_bset.name
  
  ip_address = oci_core_instance.main_vm.private_ip # Usa o IP privado da VM
  port       = 80 # Encaminha para a porta 80 (Nginx)
}

# O "Listener" (A porta que o LB escuta)
resource "oci_load_balancer_listener" "main_lb_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.main_lb.id
  name                     = "http-listener-80" # Vamos começar com HTTP na porta 80
  default_backend_set_name = oci_load_balancer_backend_set.main_lb_bset.name
  port                     = 80
  protocol                 = "HTTP"
}

# TODO: Adicionar Listener HTTPS na porta 443 com certificado SSL