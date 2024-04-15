# Exercise 6

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `k29`<br>
* Documentation: [Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)

</p>
</details>

You are tasked with defining a Pod Security Admission rule that should control the creation of Pods in the namespace `k29`.

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Creating a Pod Security Admission (PSA) Rule"](https://learning.oreilly.com/scenarios/creating-a-pod/9781098149871/).

1. Create the namespace `k29`. In the namespace, define a Pod Security Standard (PSS) with the level `restricted` that will cause a Pod to be rejected upon violation.
2. Create objects from the YAML manifests [`pod-non-root.yaml`](./pod-non-root.yaml), [`pod-root.yaml`](./pod-root.yaml), and [`pod-privileged.yaml`](./pod-privileged.yaml). Which of the Pods will be created and why?