# Exercise 1

You are tasked to lock down communication between Pods with the help of network policies. The namespace `g04` contains two Pods named `frontend` and `backend`. The `default` namespace runs a Pod named `other`. The goal is to only allow the `frontend` Pod to talk to the `backend` Pod. Any other traffic should be disallowed.

> **_NOTE:_** Without a network policy controller, network policies won't have any effect. You need to configure a network overlay solution that provides this controller. You'll have to go through some extra steps to install and enable the network provider Cilium. Without adhering to the proper prerequisites, network policies won't have any effect. You can find installation guidance in the file [cilium-setup.md](./cilium-setup.md).

1. Create the objects from the file [`setup.yaml`](./setup.yaml).
2. Inspect the Pods and wait until they transition into the "Running" status.
3. Create a network policy that blocks _all_ inter-Pod ingress communication for the namespace `g04`.
4. Verify that the Pod `frontend` in the `g04` namespace cannot talk to the Pod `backend` using the `wget` tool.
5. Verify that Pods outside of the `g04` namespace cannot talk to Pods outside of the namespace using the `wget` tool.
6. Create a network policy that allows ingress communication from the `frontend` Pod to the `backend` Pod on the port 3000. All other ingress traffic should still be disallowed.
7. Verify the correct behavior using the `wget` tool.