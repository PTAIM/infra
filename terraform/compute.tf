# Busca a imagem "Always Free" mais recente do Oracle Linux para ARM
data "oci_core_images" "vm_image" {
  compartment_id = data.oci_identity_compartment.main.id
  operating_system = "Oracle Linux"
  shape          = "VM.Standard.E2.1.Micro" # Filtra imagens compatíveis com ARM
  sort_by        = "TIMECREATED"
  sort_order     = "DESC"
}

# A Instância (VM)
resource "oci_core_instance" "main_vm" {
  compartment_id      = data.oci_identity_compartment.main.id
  display_name        = "main-app-server"
  availability_domain = data.oci_identity_availability_domain.ad.name
  
  # Shape "Always Free"
  shape = "VM.Standard.E2.1.Micro"
  shape_config {
    ocpus         = 1  # Total gratuito
    memory_in_gbs = 1 # Total gratuito
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.vm_image.images[0].id
  }

  # Conecta a VM na nossa Subnet Pública
  create_vnic_details {
    subnet_id        = oci_core_subnet.main_subnet.id
    assign_public_ip = true
  }

  # Adiciona a chave SSH e o script de cloud-init
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("${path.module}/cloud-init.sh"))
  }
}