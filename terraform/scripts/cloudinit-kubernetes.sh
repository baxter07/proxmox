#!/bin/bash

apt update && apt upgrade -y

sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
echo 'AuthenticationMethods publickey' >> /etc/ssh/sshd_config

swapoff -a
sed -i -e '/swap/d' /etc/fstab

cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt update && apt install -y vim nmap wget software-properties-common apt-transport-https ca-certificates curl gnupg2 containerd.io

systemctl restart containerd
systemctl enable containerd

mkdir -p /etc/containerd && touch /etc/containerd/config.toml
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

snap install btop
snap install helm --classic

apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

cat <<EOF | tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 0
debug: false
pull-image-on-create: false
disable-pull-on-run: false
EOF

echo "source <(kubeadm completion bash)" >> /home/<username>/.bashrc
echo "source <(kubectl completion bash)" >> /home/<username>/.bashrc
echo "source <(crictl completion bash)" >> /home/<username>/.bashrc
echo "source <(helm completion bash)" >> /home/<username>/.bashrc

# Disable cgroups v2
# https://blog.nuvotex.de/ubuntu-22-04-or-21-10-kubernetes-cgroups-v2/
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=0"/g' /etc/default/grub
update-grub

reboot
