# Exercise 9

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `r61`<br>
* Documentation: [Trivy](https://github.com/aquasecurity/trivy)

</p>
</details>

You are confronted with a set of Pods running in a namespace. Find out which of the images running in the Pods have "CRITICAL" vulnerabilities. Delete the Pods with which expose "CRITICAL" vulnerabilities. We'll use the open source security scanner [Trivy](https://github.com/aquasecurity/trivy) to perform the scan.

> [!IMPORTANT]
> Trivy is not available in a Kubernetes cluster by default. You can find installation guidance in the file [trivy-setup.md](./trivy-setup.md).

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Scanning Container Images with Trivy"](https://learning.oreilly.com/scenarios/scanning-container-images/9781098149994/).

1. Create the objects from the file [`setup.yaml`](./setup.yaml).
2. List the Pods in the namespace `r61`.
3. Install Trivy on the machine. Choose the installation method best suited for your operating system.
4. Identify the images running in those Pod.
5. Run Trivy against all of the images and identify the ones that have "CRITICAL" vulnerabilities.
6. Delete the Pods that have "CRITICAL" vulnerabilities.
