# Proxmox

A private cloud environment running virtual machines on a Proxmox host behind a pfSense firewall.

The infrastructure is provisioned using Terraform, with a Kubernetes cluster installed and configured via Ansible.

### Quick start

```bash
# Add entry to vm_templates in "ansible/host_vars/pve.yml" and create new VM
ansible-playbook playbooks/bootstrap-vm-template.yml

# Add terraform configuration for new vm in "terraform/main.tf" and apply state
terraform plan
terraform apply

# Create postgres database and user
# Add db_credentials in "ansible/host_vars/postgres.yml" then run playbook
ansible-playbook playbooks/create-postgres-db.yml

# Install and configure kubernetes cluster
ansible-playbook playbooks/install-kubernetes-cluster.yml
```
