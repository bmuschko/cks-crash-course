# Exercise 12

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `kube-system`, `default`<br>
* Documentation: [Auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/), [kube-apiserver
](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/), [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)

</p>
</details>

The DevOps team you are working on decides to keep track of the events occurring in your Kubernetes cluster. You have been tasked to configure audit logging for specific events.

> [!IMPORTANT]
> If you do not have a Linux-based cluster available, you can start one up with Vagrant and VirtualBox. You can find guidance in the file [vagrant-setup.md](../common/vagrant-setup.md).

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Configuring Audit Logging for a Log Backend"](https://learning.oreilly.com/scenarios/configuring-audit-logging/9781098150020/).

1. Create the audit policy file named `/etc/kubernetes/audit/rules/audit-policy.yaml`.
2. Add a rule for logging `Metadata`-level events for Deployments, Pods, and Services in all namespaces.
3. Add another rule for logging `RequestResponse`-level events for ConfigMaps and Secrets in the namespace `config-data`.
4. Add a third rule for ignoring `Metadata`-level events for Pod `log` and `status` commands.
5. Register the audit policy file with the API server. Write the log output to `/var/log/kubernetes/audit/logs/apiserver.log`. The maximum age of the log entries should not exceed 30 days.
6. Create a Pod named `nginx` with the image `nginx:1.21.6`.
7. Find the relevant entry in the audit log.
