variable "resource_name" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "address_prefixes" {
  type = list(string)
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "ssh_key_path" {
  type = string
}

variable "inventory_file_path" {
  type = string
}

variable "ssh_pri_key" {
  type = string
}

variable "dns_password" {
  type = string
}