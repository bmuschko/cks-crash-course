#!/usr/bin/env bash

NODE_HOST_IP=$1

# Join worker node to cluster
$(cat /vagrant/kubeadm-init.out | grep -A 2 "kubeadm join" | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')

# Add admin configuration to environment
cp /vagrant/admin.conf /etc/kubernetes/admin.conf
chmod ugo+r /etc/kubernetes/admin.conf
echo "KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/environment

# Set internal node IP address to VM host IP address
echo "KUBELET_EXTRA_ARGS=--node-ip=$NODE_HOST_IP --cgroup-driver=systemd" > /etc/default/kubelet
sudo systemctl restart kubelet