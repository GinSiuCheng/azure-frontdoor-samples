variable "host_name" {
  type = string
}

variable "host_sku" {
  type    = string
  default = "Standard_D4s_v5"
}

variable "host_username" {
  type      = string
  sensitive = true
}

variable "host_password" {
  type      = string
  sensitive = true
}