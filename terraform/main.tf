##########################
###      GENERAL       ###
##########################
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}


##########################
###     VARIABLES      ###
##########################
variable "win2022-core-hosts" {
  default = 3
}
variable "win10-hosts" {
  default = 2
}

variable "hostname_format-win-srv-2022" {
  type    = string
  default = "win-srv-2022-%02d"
}
variable "hostname_format-win-10" {
  type    = string
  default = "win-10-%02d"
}

# variable "winrm_username" {
#   type = string
#   default = "libvirt"
# }
#
# variable "winrm_password" {
#   sensitive = true
#   type = string
#   default = "hD&#GFOgf@892h"
# }
#
# variable "prefix" {
#   type = string
#   default = "advenv"
# }

# separate MAC definitions to ensure correct IP assignment
variable "mac_addresses_win10" {
  type    = list(string)
  default = [
    "50:73:0F:31:81:D1",
    "50:73:0F:31:81:D2",
  ]
}
variable "mac_addresses_win2022" {
  type    = list(string)
  default = [
    "50:73:0F:31:81:A1",
    "50:73:0F:31:81:A2",
    "50:73:0F:31:81:A3",
  ]
}
variable "ip_addresses_2022" {
  type    = list(list(string))
  default = [
    ["192.168.125.11"],
    ["192.168.125.12"],
    ["192.168.125.13"],
  ]
}
variable "ip_addresses_10" {
  type    = list(list(string))
  default = [
    ["192.168.125.101"],
    ["192.168.125.102"],
  ]
}

# variable "hostnames" {
#   type    = list(string)
#   default = [
#     "WIN-DC1",
#     "WIN-DC2"
#   ]
# }


#################################
### Resources
#################################
### NETWORK
resource "libvirt_network" "advenv_net" {
  name      = "advenv_net"
  mode      = "nat"
  bridge    = "advenvbr0"
  domain    = "advenv.local"
  addresses = ["192.168.125.0/24"]
  dhcp {
    enabled = true
  }
  dns {
    enabled = true
    forwarders {
      address = "1.1.1.1"
    }
  }
}

# resource "libvirt_domain" "dc-1" {
#   name = "dc-1"
#   cpu {
#     mode = "host-passthrough"
#   }
#   vcpu = 1
#   memory = "1024"
#   disk {
#     volume_id = libvirt_volume.MS-WIN-SRV-2016.id
#   }
#   network_interface {
#     bridge = "eth0"
#     network_id = libvirt_network.advenv_net.name
#     hostname = "dc-1"
#     addresses = ["10.10.1.1"]
#     mac = "AA:BB:CC:11:11:11"
#     wait_for_lease = true
#   }
#   
#   # arch = "x86_64"
#   # type = "kvm"
#
#   # tpm
#   # boot_device
#   # qemu_agent
# }

# resource "libvirt_domain" "dc-3" {
#   name = "dc-3"
#   cpu {
#     mode = "host-passthrough"
#   }
#   vcpu = 1
#   memory = "1024"
#   disk {
#     volume_id = libvirt_volume.ms-windows.name
#   }
#   network_interface {
#     bridge = "eth0"
#     network_id = libvirt_network.advenv_net.name
#     hostname = "dc-3"
#     addresses = ["10.10.1.3"]
#     mac = "AA:BB:CC:11:11:33"
#     wait_for_lease = true
#   }
#   
#   arch = "x86_64"
#   type = "kvm"
#
# }


### POOL
resource "libvirt_pool" "advenv_pool" {
  name = "advenv_pool"
  type = "dir"
  target {
    path = "/var/lib/libvirt/images/advenv_pool"
  }
}

### VOLUMES
resource "libvirt_volume" "win2022-core_vol" {
  name   = "${format(var.hostname_format-win-srv-2022, count.index + 1)}.qcow2"
  count  = var.win2022-core-hosts
  source = "../packer/win2022/output-qemu/Win2022_20324-Core.qcow2"
  pool   = "advenv_pool"
  format = "qcow2"
  # fix the bug that doesn't allow to destroy a pool
  depends_on       = [libvirt_pool.advenv_pool]
}
resource "libvirt_volume" "win-10_vol" {
  name   = "${format(var.hostname_format-win-10, count.index + 1)}.qcow2"
  count  = var.win10-hosts
  source = "../packer/win10/output-qemu/Win10_22h1.qcow2"
  pool   = "advenv_pool"
  format = "qcow2"
  # fix the bug that doesn't allow to destroy a pool
  depends_on       = [libvirt_pool.advenv_pool]
}


