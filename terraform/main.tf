
variable "ssh_host" {
  type = string
}

variable "ssh_user" {
  type = string
}

variable "ssh_private_key" {
  type = string
}

variable "ssh_pub_key_user1" {
  type = string
}

variable "ssh_pub_key_user2" {
  type = string
}

variable "redis_password" {
  type = string
}

variable "protonmail_password" {
  type = string
}

variable "zulip_db_password" {
  type = string
}

locals {
  proxmox_node = "<host>"

  storage_pool         = "local-vm"
  volume_snippets_path = "/var/lib/vz/snippets"

  wan_network_bridge  = "vmbr1"
  lan_network_bridge  = "vmbr2"
  lan_network_gateway = "<ip>"

  cloud_init_users = {
    user1 = var.ssh_pub_key_user1
    user2 = var.ssh_pub_key_user2
  }

  cloud_init_vms = {
    vpn = {
      desc      = "Wireguard VPN"
      clone     = "wireguard-cloudinit"
      vm_name   = "wireguard"
      vmid      = "201"
      cores     = 1
      memory    = 4096
      disk_size = "10G"
      hostname  = "wireguard"
      packages  = ["wireguard"]
    }

    postgres = {
      desc      = "Postgres Database"
      clone     = "postgres-cloudinit"
      vmid      = "221"
      cores     = 1
      memory    = 4096
      disk_size = "100G"
      packages  = ["postgresql", "acl", "python3-psycopg2"]
    }

    redis = {
      desc      = "Redis Server"
      clone     = "redis-cloudinit"
      vmid      = "231"
      cores     = 1
      memory    = 4096
      disk_size = "9420M"
      packages  = ["redis-server"]
    }

    mail = {
      desc      = "Proton mail server"
      clone     = "mail-cloudinit"
      vmid      = "241"
      cores     = 1
      memory    = 2048
      disk_size = "10000M"
    }

    gitlab = {
      desc      = "Gitlab"
      clone     = "gitlab-cloudinit"
      vmid      = "301"
      cores     = 4
      memory    = 12288
      disk_size = "104652M"
    }

    openmediavault = {
      desc      = "Openmediavault VM | NFS Rsync Filebrowser"
      clone     = "openmediavault-init"
      vmid      = 306
      os_type   = "ubuntu"
      cicustom  = ""
      cores     = 4
      memory    = 16384
      disk_size = "32G"
      hotplug   = "disk"
      disks     = [{
        type = "virtio"
        size = "128G"
      }]
    }

    kube-master = {
      desc        = "Kubernetes Master Node"
      clone       = "kube-master-cloudinit"
      vmid        = "316"
      cores       = 2
      memory      = 4096
      disk_size   = "32G"
      auto_update = false
      cloudinit = {
        filename = "cloudinit-kubernetes.sh"
      }
    }

    kube-node1 = {
      desc        = "Kubernetes Worker Node 1"
      clone       = "kube-node-cloudinit"
      vmid        = "317"
      cores       = 4
      memory      = 8192
      disk_size   = "128G"
      auto_update = false
      cloudinit = {
        filename = "cloudinit-kubernetes.sh"
      }
    }

    kube-node2 = {
      desc        = "Kubernetes Worker Node 2"
      clone       = "kube-node-cloudinit"
      vmid        = "318"
      cores       = 4
      memory      = 8192
      disk_size   = "128G"
      auto_update = false
      cloudinit = {
        filename = "cloudinit-kubernetes.sh"
      }
    }

    zulip = {
      desc      = "Zulip"
      clone     = "zulip-cloudinit"
      vmid      = "401"
      cores     = 2
      memory    = 8192
      disk_size = "53452M"
      cloudinit = {
        filename = "cloudinit-zulip.sh"
      }
    }

    meet = {
      desc      = "Jitsi Meet"
      clone     = "meet-cloudinit"
      vmid      = "411"
      cores     = 2
      memory    = 8192
      disk_size = "50G"
    }

    nextcloud = {
      desc      = "Nextcloud"
      clone     = "nextcloud-cloudinit"
      vmid      = "731"
      cores     = 1
      memory    = 4096
      disk_size = "100G"
    }
  }
}
