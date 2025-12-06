resource "libvirt_domain" "win-srv-2022" {
  count  = var.win2022-core-hosts
  name   = format(var.hostname_format-win-srv-2022, count.index + 1)
  vcpu   = 2
  memory = 5000

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = element(libvirt_volume.win2022-core_vol.*.id, count.index)
  }

  # Makes the tty0 available via `virsh console`
  console {
    type        = "pty"
    target_port = "0"
  }

  network_interface {
    network_id     = libvirt_network.advenv_net.id
    wait_for_lease = true
    mac            = element(var.mac_addresses_win2022, count.index)
    addresses      = element(var.ip_addresses_2022, count.index)
    # hostname       = element(var.hostnames, count.index)
  }
}

resource "libvirt_domain" "win-srv-2016" {
  count  = var.win2016-core-hosts
  name   = format(var.hostname_format-win-srv-2016, count.index + 1)
  vcpu   = 3
  memory = 5000

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = element(libvirt_volume.win2016-core_vol.*.id, count.index)
  }

  # Makes the tty0 available via `virsh console`
  console {
    type        = "pty"
    target_port = "0"
  }

  network_interface {
    network_id     = libvirt_network.advenv_net.id
    wait_for_lease = true
    mac            = element(var.mac_addresses_win2016, count.index)
    addresses      = element(var.ip_addresses_2016, count.index)
    # hostname       = element(var.hostnames, count.index)
  }
}

resource "libvirt_domain" "win-des-10" {
  count = var.win10-hosts
  name  = format(var.hostname_format-win-10, count.index + 1)
  cpu {
    mode = "host-passthrough"
  }
  vcpu   = 2
  memory = 7000

  disk {
    volume_id = element(libvirt_volume.win-10_vol.*.id, count.index)
  }

  # Makes the tty0 available via `virsh console`
  console {
    type        = "pty"
    target_port = "0"
  }

  network_interface {
    network_id     = libvirt_network.advenv_net.id
    wait_for_lease = true
    mac            = element(var.mac_addresses_win10, count.index)
    addresses      = element(var.ip_addresses_10, count.index)
    # hostname       = element(var.hostnames, count.index)
  }
}
