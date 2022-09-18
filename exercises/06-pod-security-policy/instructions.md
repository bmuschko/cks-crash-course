# Exercise 6

You are tasked with defining a Pod Security Policy that only allows the creation of Pods in the namespace `k29` whose containers are executed with a non-root user and in non-privileged mode. All other Pods should be denied.

> **_NOTE:_** Kubernetes requires running the PodSecurityPolicy admission controller to evaluate Pod Security policies. You can find configuration guidance in the file [psp-admission-controller-setup.md](./psp-admission-controller-setup.md). If you'd like to use a Kubernetes cluster on Vagrant, you can find guidance in the file [vagrant-setup.md](../common/vagrant-setup.md).

1. Create the objects from the file [`setup.yaml`](./setup.yaml).
2. Create a Pod Security Policy named `psp-non-root-user-non-privileged` that only allows running containers with the non-root users. Ensure the containers cannot run in privileged mode.
3. Stand up RBAC objects that use the Pod Security Policy and bind it to all service accounts in the `k29` namespace.
4. Create objects from the YAML manifests `pod-non-root.yaml`, `pod-root.yaml`, and `pod-privileged.yaml`. Which of the Pods will be created and why?