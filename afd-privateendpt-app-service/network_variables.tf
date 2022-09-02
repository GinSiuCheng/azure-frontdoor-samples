variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "bastion_subnet_address_prefixes" {
  type = list(string)
}

variable "private_endpoint_subnet_address_prefixes" {
  type = list(string)
}

variable "host_subnet_address_prefixes" {
  type = list(string)
}