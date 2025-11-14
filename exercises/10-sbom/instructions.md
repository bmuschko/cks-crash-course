# Exercise 10

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: N/A<br>
* Documentation: [Kubernetes BOM](https://kubernetes-sigs.github.io/bom/quick-start/)

</p>
</details>

A Software Bill of Materials (SBOM) is a comprehensive inventory of all components, libraries, and dependencies in a software application. The Kubernetes BOM tool helps generate, inspect, and validate SBOMs for container images and Kubernetes releases. In this exercise, you will use the BOM tool to analyze container images and create SPDX-formatted bill of materials documents.

> [!IMPORTANT]
> The BOM tool is not installed by default. You can find installation guidance in the file [bom-setup.md](./bom-setup.md).

1. Verify the installation of the BOM tool by checking the version.
2. Generate an SBOM for the container image `registry.k8s.io/kube-apiserver:v1.21.0`. Save the output to a file named `kube-apiserver-sbom.spdx`.
3. Inspect the generated SBOM document by viewing its outline structure.
4. Identify the name of the main package from the SBOM document.
5. Count how many packages are listed in total in the SBOM document.
6. Generate an SBOM for a different container image `registry.k8s.io/pause:3.9` in JSON format. Save the output to a file named `pause-sbom.spdx.json`.
