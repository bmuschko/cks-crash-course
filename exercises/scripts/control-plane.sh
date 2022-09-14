#!/usr/bin/env bash

NODE_HOST_IP=$1
POD_CIDR=$2

# Initialize control plane node
kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $NODE_HOST_IP | tee /vagrant/kubeadm-init.out

# Copy shared files between nodes
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
cp /etc/kubernetes/admin.conf /vagrant/admin.conf

# Install CNI plugin
kubectl apply -f https://projectcalico.docs.tigera.io/archive/v3.23/manifests/calico.yaml

# Set internal node IP address to VM host IP address
echo "KUBELET_EXTRA_ARGS=--node-ip=$NODE_HOST_IP --cgroup-driver=systemd" > /etc/default/kubelet
sudo systemctl restart kubelet