# Exercise 10

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `default`<br>
* Documentation: [Trivy](https://github.com/aquasecurity/trivy)

</p>
</details>

Your task is to use [Falco](https://falco.org/docs) for behavioral analysis purposes. Inspect the Falco logs, reconfigure the output format, and change the output channel to a file.

> [!IMPORTANT]
> If you do not have a Linux-based cluster available, you can start one up with Vagrant and VirtualBox. You can find guidance in the file [vagrant-setup.md](../common/vagrant-setup.md). Falco is already running as a systemd service on the worker node `kube-worker-1`.

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Configuring and Running Falco for Intrusion Detection"](https://learning.oreilly.com/scenarios/configuring-and-running/9781098150006/).

1. Open an interactive shell to the worker node.
2. Inspect the process running in the existing Pod named `malicious`. Have a look at the Falco logs and see if a rule created a log for the process.
3. Reconfigure the existing rule that creates a log for the event by changing the output to `<timestamp>,<username>,<container-id>`. Find the changed log entry in the Falco logs.
4. Reconfigure Falco to write logs to the file at `/var/logs/falco.log`. Disable the standard output channel. Ensure that Falco appends new messages to the log file.
