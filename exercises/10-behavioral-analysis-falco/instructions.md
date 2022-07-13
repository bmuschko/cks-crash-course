# Exercise 10

Your task is to configure [Falco](https://falco.org/docs) to run behavioral analysis for your cluster. Configure a rule that detects if an attacker is trying to open a shell to a container using the `bash` shell.

> **_NOTE:_** First, you will need to install Falco in your Kubernetes cluster. Refer to the [installation instructions](https://falco.org/docs/getting-started/installation/) for more information. To use a cluster with the Falco executable preinstalled, start up a Vagrant/VirtualBox Kubernetes environment. You can find guidance in the file [vagrant-setup.md](../common/vagrant-setup.md).

1. Open an interactive shell to a worker node.
2. Create a Pod named `nginx` that uses the image `nginx:1.20.2`. Ensure that the Pod transitions into the "Running" status.
3. Create a custom Falco rule in the file `falco-open-shell.yaml`. Define a rule that should detect if a `bash` command is run against a container. The priority of the rules should be treated as warning.
4. Execute the `falco` executable and point it the custom rule file. Let the process run for 2 minutes.
5. Open another shell to the same worker node.
6. Execute a `kubectl exec` command that uses the `bash` command.
7. Find the relevant output from Falco.
