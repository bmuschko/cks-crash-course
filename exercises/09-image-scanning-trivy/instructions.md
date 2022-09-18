# Exercise 9

You are confronted with a set of Pods running in a namespace. Find out which of the images running in the Pods have "CRITICAL" vulnerabilities. Delete the Pods with vulnerabilities higher than the "HIGH" severity. To perform those action, we'll use the open source security scanner called [Trivy](https://github.com/aquasecurity/trivy).

> **_NOTE:_** Trivy is not available in a Kubernetes cluster by default. You can find installation guidance in the file [trivy-setup.md](./trivy-setup.md).

1. Create the objects from the file [`setup.yaml`](./setup.yaml).
2. List the Pods in the namespace `r61`.
3. Install Trivy on the machine. Choose the installation method best suited for your operating system.
4. Identify the images running in those Pod.
5. Run Trivy against all of the images and identify the ones that have "CRITICAL" vulnerabilities.
6. Delete the Pods that have "CRITICAL" vulnerabilities.