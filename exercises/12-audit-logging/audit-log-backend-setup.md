# Configuring the Audit Log Backend

## Using Minikube

Create the file in the directory `~/.minikube/files/etc/ssl/certs`. Create the audit policy file in the directory

```
$ mkdir -p ~/.minikube/files/etc/ssl/certs
$ vim ~/.minikube/files/etc/ssl/certs/audit-log.yaml
```

Add the contents to the file `~/.minikube/files/etc/ssl/certs/audit-log.yaml`. Once you are done, you will have to restart minikube. You will not have to set the Volume for the audit policy file and log output directory.

```
$ minikube start --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-log.yaml --extra-config=apiserver.audit-log-path=- --extra-config=apiserver.audit-log-maxage=30
```

## Using a Regular Kubernetes Cluster

Refer to the [Kubernetes documentation](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/#log-backend), for setting up the audit logs in a standard Kubernetes cluster. In a nutshell, you will have to set the API server CLI options `--audit-policy-file` and `--audit-log-path`.

```
$ vim /etc/kubernetes/manifests/kube-apiserver.yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - ...
    - --audit-policy-file=/etc/kubernetes/audit-policy.yaml
    - --audit-log-path=/var/log/kubernetes/audit/audit.log
```