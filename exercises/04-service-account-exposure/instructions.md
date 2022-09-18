# Exercise 4

The cluster defines a ClusterRole and ClusterRoleBinding that map a Service Account for listing, watching, and deleting the API resources Pods, ConfigMaps, and Secrets. Two Pods defined in the namespace `k97` use the service account. You are tasked with reducing the permissions to the minimal set of permissions needed for the Pods based on the command running in the container.

1. Create the objects from the file [`setup.yaml`](./setup.yaml).
2. Inspect the Pods and wait until they transition into the "Running" status.
3. Check the logs for both Pods. You should see a success message.
4. Identify the operation that is not required and remove it from the configuration.
5. Identify which Pods requires which operation. Split up the RBAC configuration so that each Pod has its own definition on the namespace-level.
6. Check the logs for both Pods. You should still see a success message.