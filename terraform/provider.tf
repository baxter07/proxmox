
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.3"
    }
  }

  required_version = ">= 0.13.0"
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  # Enable logging
  #pm_log_enable = true
  #pm_log_file = "proxmox-plugin.log"
  #pm_log_levels = {
  #  _default = "debug"
  #  _capturelog = ""
  #}
}
