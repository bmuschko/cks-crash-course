# Exercise 10

Your task is to configure [Falco](https://falco.org/docs) to run behavioral analysis for your cluster. Configure a rule that detects if an attacker is trying to open a shell to a container using the `bash` shell. The Falco executable has already been installed.

> **_NOTE:_** Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`. The Kubernetes cluster consists of a control plane node running on `kube-control-plane` and `kube-worker-1`.

1. After bringing up the cluster using Vagrant, open an interactive shell to the VM `kube-worker-1` via the command `vagrant ssh kube-worker-1`.
2. Create a Pod named `nginx` that uses the image `nginx:1.20.2`. Ensure that the Pod transitions into the "Running" status.
3. Create a custom Falco rule in the file `falco-open-shell.yaml`. Define a rule that should detect if a `bash` command is run against a container. The priority of the rules should be treated as warning.
4. Execute the `falco` executable and point it the custom rule file. Let the process run for 2 minutes.
5. Open another shell to the VM `kube-worker-1` via the command `vagrant ssh kube-worker-1`.
6. Execute a `kubectl exec` command that uses the `bash` command.
7. Find the relevant output from Falco.
