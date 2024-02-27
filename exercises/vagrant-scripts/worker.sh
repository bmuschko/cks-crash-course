#!/usr/bin/env bash

NODE=$1
NODE_HOST_IP="192.168.56.$((20+$NODE))"

$(cat /vagrant/kubeadm-init.out | grep -A 2 "kubeadm join" | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')

# deb packages for kubelet on pkgs.k8s.io seem to include a systemd service definition for redhat machines #3276
# apply same sed fix as in https://github.com/kubernetes/release/pull/3279
sed -i 's;/etc/sysconfig/kubelet;/etc/default/kubelet;g' /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
echo "KUBELET_EXTRA_ARGS=--node-ip=$NODE_HOST_IP --cgroup-driver=systemd" > /etc/default/kubelet
systemctl restart kubelet

cp /vagrant/admin.conf /etc/kubernetes/admin.conf
chmod ugo+r /etc/kubernetes/admin.conf
echo "KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/environment