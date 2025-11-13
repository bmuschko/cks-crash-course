# Exercise 9

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `encryption-test`<br>
* Documentation: [Cilium](https://docs.cilium.io/), [WireGuard](https://www.wireguard.com/)

</p>
</details>

Cilium is a CNI (Container Network Interface) plugin that provides networking, security, and observability for Kubernetes clusters. WireGuard is a modern VPN protocol that can be used to encrypt network traffic between nodes. In this exercise, you will configure Cilium with WireGuard to enable transparent encryption of Pod-to-Pod traffic.

> [!IMPORTANT]
> This exercise requires a cluster with Cilium installed as the CNI. WireGuard must be available on the cluster nodes. You can find installation guidance in the file [cilium-setup.md](./cilium-setup.md).

> [!NOTE]
> If you do not already have a cluster with Cilium, you can create one by using minikube with the CNI plugin flag or refer to the [Cilium installation guide](https://docs.cilium.io/en/stable/gettingstarted/).

1. Check the Cilium status to confirm WireGuard encryption is active.
2. List the cluster nodes. You should have at least 2 worker nodes. Assign the label `node-role=node1` to worker node 1, and the label `node-role=node2` to worker node 2. Verify the correct assignment of labels.
3. Create the Pods in the namespace `encryption-test` by applying the YAML manifest in [`setup.yaml`](./setup.yaml).
4. Make a network call from `pod2` to `pod1`. The network packets should be encypted by WireGuard.
5. Create a CiliumNetworkPolicy that allows the call from `pod2` to `pod1`.
6. Make a network call from `pod2` to `pod1`. The communication should still be allowed.
