variable "node_name" {
  type    = string
  default = "pve"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "win2022-core-hosts" {
  type    = number
  default = 3
}
variable "win2016-core-hosts" {
  type    = number
  default = 2
}
variable "win10-hosts" {
  type    = number
  default = 2
}

variable "hostname_format-win-srv-2022" {
  type    = string
  default = "win-srv-2022-%02d"
}
variable "hostname_format-win-srv-2016" {
  type    = string
  default = "win-srv-2016-%02d"
}
variable "hostname_format-win-10" {
  type    = string
  default = "win-10-%02d"
}

# separate MAC definitions to ensure correct IP assignment
variable "mac_addresses_win2022" {
  type = list(string)
  default = [
    "50:73:0F:31:81:A1",
    "50:73:0F:31:81:A2",
    "50:73:0F:31:81:A3",
  ]
}
variable "ip_addresses_2022" {
  type = list(list(string))
  default = [
    ["192.168.125.11"], # dc01
    ["192.168.125.13"], # dc03
    ["192.168.125.21"], # srv01
  ]
}

variable "mac_addresses_win2016" {
  type = list(string)
  default = [
    "50:73:0F:31:81:B1",
    "50:73:0F:31:81:B2",
  ]
}
variable "ip_addresses_2016" {
  type = list(list(string))
  default = [
    ["192.168.125.12"], # dc02
    ["192.168.125.22"], # srv02
  ]
}

variable "mac_addresses_win10" {
  type = list(string)
  default = [
    "50:73:0F:31:81:D1",
    "50:73:0F:31:81:D2",
  ]
}
variable "ip_addresses_10" {
  type = list(list(string))
  default = [
    ["192.168.125.101"],
    ["192.168.125.102"],
  ]
}
