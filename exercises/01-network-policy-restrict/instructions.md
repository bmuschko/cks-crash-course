# Exercise 1

You are tasked to lock down communication between Pods with the help of network policies. The namespace `g04` contains two Pods named `frontend` and `backend`. The `default` namespace and other namespaces than `g04` run Pods as well. The goal is to only allow the `frontend` Pod to talk to the `backend` Pod. Any other traffic should be disallowed.

1. Create the Pods from the file `setup.yaml`.
2. Inspect the Pods and wait until they transition into the "Running" status.
3. Create a network policy that blocks _all_ inter-Pod communication for the namespace `g04`.
4. Verify that the Pod `frontend` in the `g04` namespace cannot talk to the Pod `backend` using the `wget` tool.
5. Verify that Pods outside of the `g04` namespace cannot talk to Pods outside of the namespace using the `wget` tool.
6. Create a network policy that allows communication from the `frontend` Pod to the `backend` Pod.
7. Verify the correct behavior using the `wget` tool.