#!/usr/bin/env bash

curl -s https://falco.org/repo/falcosecurity-packages.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y
apt install -y dkms make linux-headers-$(uname -r)
apt install -y clang llvm
apt install -y dialog
sudo apt-get install -y falco=0.33.1