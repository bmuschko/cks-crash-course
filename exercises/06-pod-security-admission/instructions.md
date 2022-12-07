# Exercise 6

You are tasked with defining a Pod Security Admission rule that should control the creation of Pods in the namespace `k29`.

1. Create the namespace `k29`. In the namespace, define a Pod Security Standard (PSS) with the level `restricted` that will cause a Pod to be rejected upon violation.
2. Create objects from the YAML manifests [`pod-non-root.yaml`](./pod-non-root.yaml), [`pod-root.yaml`](./pod-root.yaml), and [`pod-privileged.yaml`](./pod-privileged.yaml). Which of the Pods will be created and why?