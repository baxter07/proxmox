
resource "proxmox_vm_qemu" "pfsense" {

  target_node = local.proxmox_node
  clone       = "pfsense-base"

  desc = "Pfsense Firewall / Router / Proxy"
  name = "pfsense"
  vmid = "<vmid>"

  agent  = 1
  onboot = true

  cores   = 2
  sockets = 1
  cpu     = "host"

  memory = 8192

  bootdisk = "virtio0"

  disk {
    storage = local.storage_pool
    type    = "virtio"
    format  = "qcow2"
    size    = "32G"
  }

  network {
    bridge = local.wan_network_bridge
    model  = "virtio"
  }

  network {
    bridge = local.lan_network_bridge
    model  = "virtio"
  }

  vga {
    type   = "qxl"
    memory = 0
  }
}