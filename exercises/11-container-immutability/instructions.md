# Excercise 11

You are an administrator of a Kubernetes cluster running a couple of existing Pods. It's your job to inspect the containers defined by the Pods for immutability. Delete all Pods that do not follow typical immutability best practices.

1. Create the objects from the file [`setup.yaml`](./setup.yaml).
2. List the Pods in the namespace `h92`.
3. Identify the Pods in the namespace that cannot be considered to run immutable containers.
4. Delete the Pods with mutable containers from the namespace. Which of the Pods are left running?