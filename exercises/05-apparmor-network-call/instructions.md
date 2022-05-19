# Exercise 5

You are tasked to prevent a Pod from making any network calls with the help of AppArmor. You will create a AppArmor profile, and enforce the profile on the node that runs a specific Pod.

> **_NOTE:_** AppArmor is a Linux-only tool. For that purpose, this exercise uses a Linux-based Kubernetes cluster running VMs. Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`. The Kubernetes cluster consists of a control plane node running on `kube-control-plane` and `kube-worker-1`.

1. Check the logs of the Pod named `network-call`. What do you think the process running in the container is doing?
2. Create an AppArmor profile file named `network-deny`. The profile should not allow any network traffic. Reference the [documentation](https://gitlab.com/apparmor/apparmor/-/wikis/QuickProfileLanguage) for more information.
3. Add the profile to the set of rules in enforce mode.
4. Apply the profile to the Pod named `network-call` running in the `default` namespace.
5. Check the logs of the Pod to ensure that network calls cannot be made anymore.