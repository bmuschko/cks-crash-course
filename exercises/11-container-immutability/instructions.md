# Exercise 11

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `h92`<br>
* Documentation: [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)

</p>
</details>

You are an administrator of a Kubernetes cluster running a couple of existing Pods. It's your job to inspect the containers defined by the Pods for immutability. Delete all Pods that do not follow typical immutability best practices.

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Identifying Immutable Containers"](https://learning.oreilly.com/scenarios/identifying-immutable-containers/9781098150013/).

1. Create the objects from the file [`setup.yaml`](./setup.yaml).
2. List the Pods in the namespace `h92`.
3. Identify the Pods in the namespace that cannot be considered to run immutable containers.
4. Delete the Pods with mutable containers from the namespace. Which of the Pods are left running?
