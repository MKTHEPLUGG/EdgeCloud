variable "iso_url" {
  type    = string
  default = "https://ubuntu.cu.be/24.04/ubuntu-24.04.1-live-server-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  default = "https://ubuntu.cu.be/24.04/SHA256SUMS"
}

# "https://ubuntu.cu.be/24.04/ubuntu-24.04.1-live-server-amd64.iso"
# https://cloud-images.ubuntu.com/releases/noble/release/SHA256SUMS
# https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-server-cloudimg-amd64.img

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "ssh_password" {
  type    = string
  default = "ubuntu"
}
