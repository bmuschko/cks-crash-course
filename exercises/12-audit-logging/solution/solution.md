# Solution

## Creating the Audit Policy File

Create the audit policy file. The following paths assume a minikube environment. For any other Kubernetes cluster, you can pick any other path.

```
$ mkdir -p ~/.minikube/files/etc/ssl/certs
$ vim ~/.minikube/files/etc/ssl/certs/audit-log.yaml
```

Edit the audit policy file and add the relevant rules. The final content of the file could look as follows.

```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  resources:
  - group: ""
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

## Creating Audit Log Entries

Create a Pod to produce an audit log entry.

```
$ kubectl run nginx --image=nginx:1.21.6
pod/nginx created
```

Check the audit log of type `audit.k8s.io/v1`. If you are using minikube, you should find an entry for the Pod creation event in the logs of the Pod named `kube-apiserver-minikube` in the namespace `kube-system`. Check the audit log file if you are using a different Kubernetes environment than Minikube.

```
$ kubectl logs kube-apiserver-minikube -n kube-system | grep audit.k8s.io/v1
{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"6c3b62fc-41e7-4f74-b8aa-82e943039013","stage":"ResponseComplete","requestURI":"/api/v1/namespaces/default/pods?fieldManager=kubectl-run","verb":"create","user":{"username":"minikube-user","groups":["system:masters","system:authenticated"]},"sourceIPs":["192.168.64.1"],"userAgent":"kubectl/v1.23.5 (darwin/amd64) kubernetes/c285e78","objectRef":{"resource":"pods","namespace":"default","name":"nginx","apiVersion":"v1"},"responseStatus":{"metadata":{},"code":201},"requestReceivedTimestamp":"2022-05-18T15:48:37.388237Z","stageTimestamp":"2022-05-18T15:48:37.395604Z","annotations":{"authorization.k8s.io/decision":"allow","authorization.k8s.io/reason":""}}
{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"3afbcd1e-1c1b-4ae5-800d-b3a5c78ec665","stage":"RequestReceived","requestURI":"/api/v1/namespaces/default/pods/nginx","verb":"get","user":{"username":"system:node:minikube","groups":["system:nodes","system:authenticated"]},"sourceIPs":["192.168.64.61"],"userAgent":"kubelet/v1.22.3 (linux/amd64) kubernetes/c920368","objectRef":{"resource":"pods","namespace":"default","name":"nginx","apiVersion":"v1"},"requestReceivedTimestamp":"2022-05-18T15:48:37.414676Z","stageTimestamp":"2022-05-18T15:48:37.414676Z"}
{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"3afbcd1e-1c1b-4ae5-800d-b3a5c78ec665","stage":"ResponseComplete","requestURI":"/api/v1/namespaces/default/pods/nginx","verb":"get","user":{"username":"system:node:minikube","groups":["system:nodes","system:authenticated"]},"sourceIPs":["192.168.64.61"],"userAgent":"kubelet/v1.22.3 (linux/amd64) kubernetes/c920368","objectRef":{"resource":"pods","namespace":"default","name":"nginx","apiVersion":"v1"},"responseStatus":{"metadata":{},"code":200},"requestReceivedTimestamp":"2022-05-18T15:48:37.414676Z","stageTimestamp":"2022-05-18T15:48:37.427821Z","annotations":{"authorization.k8s.io/decision":"allow","authorization.k8s.io/reason":""}}
```