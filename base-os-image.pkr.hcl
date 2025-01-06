acker {
  required_plugins {
    vsphere = {
      version = "~> 1"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

source "vsphere-iso" "linux_vm" {
  vcenter_server      = "10.30.0.30"
  username            = "administrator@normslab.com"
  password            = "Ph1shstix!"
  cluster             = "Mazinger"
  datacenter          = "Mazinger-NormsLab"
  folder              = "CX23"
  datastore           = "CX_Mazinger"
  host                = "10.30.30.110"
  insecure_connection = true

  vm_name             = "Base OS"
  CPUs                = 4
  RAM                 = 8192
  RAM_reserve_all     = true
  communicator        = "ssh"
  ssh_username        = "root"
  ssh_password        = "ph1shstix"
  disk_controller_type = ["lsilogic-sas"]
  firmware            = "bios"
  guest_os_type       = "centos7_64Guest"
  iso_paths           = ["[CX_Mazinger] ISO/AlmaLinux-9.3-x86_64-minimal.iso"]

  network_adapters {
    network      = "VM Network"
    network_card = "vmxnet3"
  }

  storage {
    disk_size             = 51200
    disk_thin_provisioned = true
  }

  convert_to_template = false

  boot_wait = "3s"

  boot_command = ["<esc><wait>linux inst.text inst.ks=https://raw.githubusercontent.com/ncanilan/GoldenImage/main/partitions/base.cfg<enter>"]

}

variable "name" {
  description = "The name of the build"
  default     = "linux-server"
}


build {
  sources = ["source.vsphere-iso.linux_vm"]
}

