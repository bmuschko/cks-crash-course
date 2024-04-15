# Exercise 5

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `default`<br>
* Documentation: [Restrict a Container's Access to Resources with AppArmor](https://kubernetes.io/docs/tutorials/security/apparmor/)

</p>
</details>

You are tasked to prevent a Pod from making any network calls with the help of [AppArmor](https://apparmor.net/). You will create a AppArmor profile, and enforce the profile on the node that runs a specific Pod.

> [!IMPORTANT]
> AppArmor is a Linux-only tool. For that reason, this exercise requires a cluster running on Linux. If you do not have a Linux-based cluster available, you can start one up with Vagrant and VirtualBox. You can find guidance in the file [vagrant-setup.md](../common/vagrant-setup.md).

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Using AppArmor to Prevent Any Incoming and Outgoing Network Traffic"](https://learning.oreilly.com/scenarios/using-apparmor-to/9781098149819/).

1. Execute the following command in the cluster: `kubectl run network-call --image=alpine/curl:3.14 -- /bin/sh -c 'while true; do ping -c 1 google.com; sleep 5; done'`. If you are using the Vagrant setup then this will happen automatically.
2. Check the logs of the Pod named `network-call`. What do you think the process running in the container is doing?
3. Create an AppArmor profile file named `network-deny`. The profile should not allow any network traffic. Reference the [documentation](https://gitlab.com/apparmor/apparmor/-/wikis/QuickProfileLanguage) for more information.
4. Add the profile to the set of rules in enforce mode.
5. Apply the profile to the Pod named `network-call` running in the `default` namespace.
6. Check the logs of the Pod to ensure that network calls cannot be made anymore.