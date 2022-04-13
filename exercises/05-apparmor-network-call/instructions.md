# Exercise 5

You are tasked to prevent a Pod from making any network calls with the help of AppArmor. You will create a AppArmor profile, and enforce the profile on the node that runs a specific Pod.

> **_NOTE:_** Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`. The Kubernetes cluster consists of a control plane node running on `kube-controlplane` and `kube-worker-1`.

1. Create an AppArmor profile file named `network-deny`. The profile should not allow any network traffic. Reference the [documentation](https://gitlab.com/apparmor/apparmor/-/wikis/QuickProfileLanguage) for more information.
2. Add the profile to the set of rules in enforce mode.
3. Apply the profile to the Pod named `alpine-curl` running in the `default` namespace.
4. Check the logs of the Pod to ensure that network calls cannot be made anymore.