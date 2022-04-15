# Exercise 6

You are tasked with defining a Pod Security Policy that only allows the creation of Pods in the namespace `k29` whose containers are executed with the root user. All other Pods should be denied.

1. Create the objects from the file `setup.yaml`.
2. Enable the admission controller plugin that evaluates Pod Security Policies.
3. Ensure that the cluster nodes are in the "Running" status.
4. Create a Pod Security Policy named `psp-non-root-user` that only allows running containers with the root user.
5. Stand up RBAC objects that use the Pod Security Policy and bind it to the service account `sa-gov` in the `k29` namespace.
6. Create objects from the YAML manifests `pod-non-root.yaml` and `pod-root.yaml`. Which of the Pods should be created?