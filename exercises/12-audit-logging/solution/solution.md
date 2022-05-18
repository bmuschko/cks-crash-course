# Solution

Create the audit policy file. Create the file in the directory `~/.minikube/files/etc/ssl/certs` if you are using Minikube. If you are using a different Kubernetes environment, you can go with any other directory.

```
$ mkdir -p ~/.minikube/files/etc/ssl/certs
$ touch ~/.minikube/files/etc/ssl/certs/audit-log.yaml
```

Edit the audit policy file and add the relevant rules. The final content of the file could look as follows.

```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  resources:
  - group: "apps"
    resources: ["pods", "deployments", "services"]
- level: RequestResponse
  resources:
  - group: ""
    resources: ["configmaps", "secrets"]
  namespaces: ["config-data"]
- level: None
  resources:
  - group: ""
    resources: ["pods/log", "pods/status"]
```

Set the relevant configuration options for enabling the audit log in the command line options of the API server. If you are using Minikube, you will have to restart the process. You will not have to set the Volume for the audit policy file and log output directory. Refer to the [Kubernetes documentation](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/#log-backend), for setting up the audit logs in a standard Kubernetes cluster.

```
$ minikube start --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-log.yaml --extra-config=apiserver.audit-log-path=- --extra-config=apiserver.audit-log-maxage=30
```

Create a Pod to produce an audit log entry.

```
$ kubectl run nginx --image=nginx:1.21.6
```

Check the audit log file at `~/events.log`. You should find an entry for the Pod creation event.

```
```