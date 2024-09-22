packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "ubuntu" {
  iso_url           = var.iso_url
  output_directory  = "output-ubuntu-image"
  disk_size         = 20000
  format            = "raw"
  headless          = true
  qemuargs          = [
    ["-display", "vnc=:1"],  # binds VNC to display 1
    ["-serial", "mon:stdio"], # enables serial output
    ["-m", "2048"],
     ["-net", "user,hostfwd=tcp::2222-:22"],
    ["-net", "nic"]
  ]
  iso_checksum      = "sha256:78547d336e4c8f98864fd3088a7ab393d7ab970885263578404bad7fc7c5e5d8"
   ssh_port          = 2222
  ssh_username      = var.ssh_username
  ssh_password      = var.ssh_password
  ssh_timeout            = "20m"
}

build {
  sources = ["source.qemu.ubuntu"]

  provisioner "shell" {
    environment_vars = [
      "IMAGE_NAME=$(basename ${var.iso_url})"
    ]
    inline = [
      "sudo apt-get update -y && sudo apt upgrade -y",
      "sudo apt install -y openssh-server",
      "sudo systemctl enable ssh",
      "sudo systemctl start ssh"
      "sudo cloud-init clean",
      "sudo chmod +x /home/sysadmin/deploy-script.sh"
    ]
  }

  provisioner "file" {
    source      = "config/cloud-config.yaml"
    destination = "/etc/cloud/cloud.cfg.d/99_custom.cfg"
  }

  provisioner "file" {
    source      = "config/p10k.zsh"
    destination = "/home/sysadmin/.p10k.zsh"
  }

  provisioner "file" {
    source      = "config/deploy-script.sh"
    destination = "/home/sysadmin/deploy-script.sh"
  }

  post-processor "shell-local" {
    inline = [
      "qemu-img convert -O raw output-ubuntu-image/packer-qemu output-ubuntu-image/ubuntu-custom-image.raw"
    ]
  }
}
