provider "ibm" {}

module "camtags" {
  source = "../Modules/camtags"
}

variable "public_ssh_key" {
  description = "Public SSH key used to connect to the virtual guest"
}

variable "datacenter" {
  description = "Softlayer datacenter where infrastructure resources will be deployed"
}

variable "hostname" {
  description = "Hostname of the virtual instance (small flavor) to be deployed"
  default     = "debian-small"
}

## This will create a new SSH key that will show up under the \
# Devices>Manage>SSH Keys in the SoftLayer console.
#resource "ibm_compute_ssh_key" "orpheus_public_key" {
#  label      = "Orpheus Public Key"
#  public_key = "${var.public_ssh_key}"
#}

variable "domain" {
  description = "VM domain"
}

# Create a new virtual guest using image "Debian"
resource "ibm_compute_vm_instance" "debian_small_virtual_guest" {
  hostname                 = "${var.hostname}"
  os		           = "CENTOS_7_64"
  domain                   = "${var.domain}"
  datacenter               = "${var.datacenter}"
  network_speed            = 100
  hourly_billing           = true
  private_network_only     = false
  cores                    = 1
  memory                   = 1024
  disks                    = [25]
  force
  user_metadata            = "{\"value\":\"newvalue\"}"
  tags                     = ["${module.camtags.tagslist}"]
}

output "vm_ip" {
  value = "Public : ${ibm_compute_vm_instance.debian_small_virtual_guest.ipv4_address}"
}
