terraform {
  required_version = ">= 0.13"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.86.0"
    }
  }
}

provider "proxmox" {
}

resource "proxmox_virtual_environment_vm" "win-srv-2022" {
  count     = var.win2022-core-hosts
  name      = format(var.hostname_format-win-srv-2022, count.index + 1)
  node_name = var.node_name
  vm_id     = var.vm_id_start + count.index
  tags      = ["advenv"]


  clone {
    vm_id = 48453
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 5000
  }

  network_device {
    bridge      = var.bridge
    model       = "virtio"
    mac_address = element(var.mac_addresses_win2022, count.index)
  }

  serial_device {}

  lifecycle {
    create_before_destroy = true
  }
}

