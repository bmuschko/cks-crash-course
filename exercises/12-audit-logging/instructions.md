# Exercise 12

The DevOps team you are working on decides to keep track of the events occurring in your Kubernetes cluster. In your role as an administrator, you are tasked to configure audit logging for specific events.

1. Create the audit policy file named `audit-log.yaml`.
2. Add a rule for logging `Metadata`-level events for Deployments, Pods, and Services in all namespaces.
3. Add another rule for logging `RequestResponse`-level events for ConfigMaps and Secrets in the namespace `config-data`.
4. Add a third rule for ignoring `Metadata`-level events for Pod `log` and `status` commands.
5. Register the audit policy file with the API server. Write the log output to the file `events.log` in any directory of your choice. The maximum age of the log entries should not exceed 30 days.
6. Create a Pod and find the relevant entry in the audit log file.