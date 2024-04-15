# Exercise 3

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: N/A<br>
* Documentation: [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)

</p>
</details>

You logged into a Kubernetes clusters and are planning to verifying the validity of the Kubernetes binaries `kubectl`, `kubeadm`, and `kubelet`. Use the SHA256 checksums for comparison.

> [!IMPORTANT]
> Consult the OS-specific commands in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/tools/#kubectl) for reference. You may have to install SHA checksum tool depending on your operating system. On MacOSX use the tool `shasum`, on Linux use the tool `sha256sum`. Use the tool `certutil` if you are working on Windows.

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Verifying Platform Binaries with Checksums"](https://learning.oreilly.com/scenarios/verifying-platform-binaries/9781098149680/).

1. Create the directory named `kubernetes-bin`. Navigate to the directory.
2. Copy the script `setup.sh` into the new directory and run it. It will download the Kubernetes binaries for Linux AMD64.
3. Inspect the downloaded files.
4. Verify that the downloaded binaries are compatible with the Kubernetes version 1.23.5 by comparing them with the corresponding checksum files.
