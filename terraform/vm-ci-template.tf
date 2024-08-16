
//noinspection HILUnresolvedReference
locals {
  cloud_config_vms = { for key, value in local.cloud_init_vms : key => value if lookup(value, "os_type", "cloud-init") == "cloud-init" }
  cloud_init_vm_templates = {
    for key, value in local.cloud_config_vms : key => templatefile("${path.module}/templates/cloud-init-config.yml", {
      ci_users           = local.cloud_init_users
      auto_update        = lookup(value, "auto_update", true)
      hostname           = lookup(value, "hostname", key)
      packages           = lookup(value, "packages", [])
      init_script_content = (!contains(keys(value), "cloudinit") ? "" :
        templatefile("${path.module}/scripts/${value.cloudinit.filename}",
      lookup(value.cloudinit, "args", {})))
    })
  }
}

resource "null_resource" "cloud_init_vm_config" {
  for_each = local.cloud_config_vms

  connection {
    type        = "ssh"
    host        = var.ssh_host
    user        = var.ssh_user
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    content     = local.cloud_init_vm_templates[each.key]
    destination = "${local.volume_snippets_path}/ci-${each.key}-config.yml"
  }

  triggers = {
    "cloud_init_vm[${each.key}]" = local.cloud_init_vm_templates[each.key]
  }
}

resource "proxmox_vm_qemu" "cloud_init_vm" {
  for_each = local.cloud_init_vms

  depends_on = [
    null_resource.cloud_init_vm_config,
  ]

  target_node = local.proxmox_node
  clone       = each.value.clone

  name = lookup(each.value, "vm_name", each.key)
  desc = each.value.desc
  vmid = each.value.vmid

  agent    = 1
  onboot   = lookup(each.value, "onboot", true)
  boot     = lookup(each.value, "boot", "c")
  bootdisk = lookup(each.value, "bootdisk", "scsi0")

  os_type = lookup(each.value, "os_type", "cloud-init")
  cloudinit_cdrom_storage = lookup(each.value, "os_type", "cloud-init") == "cloud-init" ? local.storage_pool : ""

  cicustom   = lookup(each.value, "cicustom", "user=local:snippets/ci-${each.key}-config.yml")
  ipconfig0  = lookup(each.value, "ipconfig0", "ip=dhcp")
  nameserver = lookup(each.value, "nameserver", local.lan_network_gateway)

  cpu     = "host"
  sockets = 1
  cores   = each.value.cores
  memory  = each.value.memory

  hotplug = lookup(each.value, "hotplug", null)

  disk {
    type    = lookup(each.value, "disk_type", "scsi")
    format  = lookup(each.value, "disk_format", "qcow2")
    storage = local.storage_pool
    size    = lookup(each.value, "disk_size", "32G")
  }

  dynamic "disk" {
    for_each = lookup(each.value, "disks", [])

    content {
      type    = lookup(disk.value, "type", "scsi")
      format  = lookup(disk.value, "format", "qcow2")
      storage = lookup(disk.value, "storage", "local-vm")
      size    = lookup(disk.value, "size", "32G")
      volume  = lookup(disk.value, "volume", null)
      slot    = lookup(disk.value, "slot", null)
    }
  }

  network {
    model   = "virtio"
    bridge  = lookup(each.value, "bridge", local.lan_network_bridge)
    macaddr = lookup(each.value, "macaddr", null)
  }

  lifecycle {
    ignore_changes = [network]
  }
}