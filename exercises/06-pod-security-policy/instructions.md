# Exercise 6

You are tasked with defining a Pod Security Policy that only allows the creation of Pods in the namespace `k29` whose containers are executed with a non-root user and in non-privileged mode. All other Pods should be denied.

> **_NOTE:_** Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`. The Kubernetes cluster consists of a control plane node running on `kube-control-plane` and `kube-worker-1`. You can SSH into a VM using the command `vagrant ssh <vm-name>`.

1. Enable the admission controller plugin that evaluates Pod Security Policies.
2. Ensure that the cluster nodes are in the "Running" status.
3. Create the objects from the file `setup.yaml`.
4. Create a Pod Security Policy named `psp-non-root-user-non-privileged` that only allows running containers with the non-root users. Ensure the containers cannot run in privileged mode.
5. Stand up RBAC objects that use the Pod Security Policy and bind it to all service accounts in the `k29` namespace.
6. Create objects from the YAML manifests `pod-non-root.yaml`, `pod-root.yaml`, and `pod-privileged.yaml`. Which of the Pods will be created and why?