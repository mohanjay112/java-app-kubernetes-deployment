#!/bin/bash -x

# Disable swap
sudo swapoff -a && sudo sed -i '/swap/d' /etc/fstab

# Kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Sysctl params
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

# Install containerd
sudo apt update
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl enable containerd
sudo systemctl restart containerd

# Install Kubernetes tools
KUBEVERSION=v1.30
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

# Allow API server port
sudo ufw allow 6443/tcp

sleep 120

# kubeadm init
IPADDR=192.168.33.2
POD_CIDR=10.244.0.0/16
NODENAME=kubemaster

sudo kubeadm init \
  --control-plane-endpoint=$IPADDR \
  --pod-network-cidr=$POD_CIDR \
  --node-name $NODENAME \
  --ignore-preflight-errors=Swap &> /tmp/initout.log

# Extract join command if successful
if grep -q "kubeadm join" /tmp/initout.log; then
  grep "kubeadm join" /tmp/initout.log -A2 > /vagrant/cltjoincommand.sh
  chmod +x /vagrant/cltjoincommand.sh
else
  echo "❌ kubeadm init failed!" >&2
  cat /tmp/initout.log
  exit 1
fi

# Apply Calico network
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/calico.yaml
