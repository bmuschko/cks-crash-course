# Solution

## Creating the Audit Policy File

Shell into the control plane node with the following command.

```
$ vagrant ssh kube-control-plane
```

Create the directory that's going to hold the audit policy file. It does not exist yet.

```
$ sudo mkdir -p /etc/kubernetes/audit/rules
```

Create the file audit policy file with the following command.

```
$ sudo vim /etc/kubernetes/audit/rules/audit-policy.yaml
```

Add the rules asked about in the instructions. The content of the final audit policy file could look as follows.

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

## Configuring the API Server

Configure the API server to consume the audit policy file by editing its configuration file.

```
$ sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Provide a pointer to the log path and log age. Make sure to define and mount the relevant files and directories. The relevant configuration needed is shown below.

```yaml
...
spec:
  containers:
  - command:
    - kube-apiserver
    - --audit-policy-file=/etc/kubernetes/audit/rules/audit-policy.yaml
    - --audit-log-path=/var/log/kubernetes/audit/logs/apiserver.log
    - --audit-log-maxage=30
    ...
    volumeMounts:
    - mountPath: /etc/kubernetes/audit/rules/audit-policy.yaml
      name: audit
      readOnly: true
    - mountPath: /var/log/kubernetes/audit/logs/
      name: audit-log
      readOnly: false
  ...
  volumes:
  - name: audit
    hostPath:
      path: /etc/kubernetes/audit/rules/audit-policy.yaml
      type: File
  - name: audit-log
    hostPath:
      path: /var/log/kubernetes/audit/logs/
      type: DirectoryOrCreate
```

## Creating Audit Log Entries

Create a Pod to produce an audit log entry.

```
$ kubectl run nginx --image=nginx:1.21.6
pod/nginx created
```

Check audit log entries of type `audit.k8s.io/v1` in the file `/var/log/kubernetes/audit/logs/apiserver.log`.
```
$ sudo cat /var/log/kubernetes/audit/logs/apiserver.log | grep audit.k8s.io/v1
{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"ee3ad41f-e863-4186-b890-f32ab4066f8f","stage":"ResponseComplete","requestURI":"/api/v1/services","verb":"list","user":{"username":"system:apiserver","uid":"521bb98f-fbc7-4e61-b96e-0a1510efabad","groups":["system:masters"]},"sourceIPs":["::1"],"userAgent":"kube-apiserver/v1.23.17 (linux/amd64) kubernetes/953be89","objectRef":{"resource":"services","apiVersion":"v1"},"responseStatus":{"metadata":{},"code":200},"requestReceivedTimestamp":"2023-04-09T19:58:17.603586Z","stageTimestamp":"2023-04-09T19:58:17.605138Z","annotations":{"authorization.k8s.io/decision":"allow","authorization.k8s.io/reason":""}}
{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"a8a05be4-258a-4c78-80ce-e4eca85b51e1","stage":"ResponseComplete","requestURI":"/api/v1/services","verb":"list","user":{"username":"system:apiserver","uid":"521bb98f-fbc7-4e61-b96e-0a1510efabad","groups":["system:masters"]},"sourceIPs":["::1"],"userAgent":"kube-apiserver/v1.23.17 (linux/amd64) kubernetes/953be89","objectRef":{"resource":"services","apiVersion":"v1"},"responseStatus":{"metadata":{},"code":200},"requestReceivedTimestamp":"2023-04-09T19:58:17.603637Z","stageTimestamp":"2023-04-09T19:58:17.605143Z","annotations":{"authorization.k8s.io/decision":"allow","authorization.k8s.io/reason":""}}
{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"f04af6b0-5716-4593-ac43-133becd6e417","stage":"RequestReceived","requestURI":"/api/v1/namespaces/default/services/kubernetes","verb":"get","user":{"username":"system:apiserver","uid":"521bb98f-fbc7-4e61-b96e-0a1510efabad","groups":["system:masters"]},"sourceIPs":["::1"],"userAgent":"kube-apiserver/v1.23.17 (linux/amd64) kubernetes/953be89","objectRef":{"resource":"services","namespace":"default","name":"kubernetes","apiVersion":"v1"},"requestReceivedTimestamp":"2023-04-09T19:58:18.441262Z","stageTimestamp":"2023-04-09T19:58:18.441262Z"}
{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"f04af6b0-5716-4593-ac43-133becd6e417","stage":"ResponseComplete","requestURI":"/api/v1/namespaces/default/services/kubernetes","verb":"get","user":{"username":"system:apiserver","uid":"521bb98f-fbc7-4e61-b96e-0a1510efabad","groups":["system:masters"]},"sourceIPs":["::1"],"userAgent":"kube-apiserver/v1.23.17 (linux/amd64) kubernetes/953be89","objectRef":{"resource":"services","namespace":"default","name":"kubernetes","apiVersion":"v1"},"responseStatus":{"metadata":{},"code":200},"requestReceivedTimestamp":"2023-04-09T19:58:18.441262Z","stageTimestamp":"2023-04-09T19:58:18.442078Z","annotations":{"authorization.k8s.io/decision":"allow","authorization.k8s.io/reason":""}}
```