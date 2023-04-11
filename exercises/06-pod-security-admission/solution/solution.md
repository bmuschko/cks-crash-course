# Solution

## Creating the Namespace

Start by defining the namespace that defines a Pod Security Standard as a label. The contents stored in the YAML manifest file `namespace.yaml` could look as follows:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: k29
  labels:
    pod-security.kubernetes.io/enforce: restricted
```

Create the object.

```
$ kubectl apply -f namespace.yaml
namespace/k29 created
```

## Enforcing the Behavior

The Pod defined by the YAML manifest `pod-non-root.yaml` runs the container with the user ID 1001. The container does not require to run in privileged mode.

```
$ kubectl apply -f pod-non-root.yaml
pod/non-root-user-container created
$ kubectl get pods -n k29
NAME                      READY   STATUS    RESTARTS   AGE
non-root-user-container   1/1     Running   0          11s
```

The Pod defined by the YAML manifest `pod-root.yaml` runs the container with the root user and therefore is not allowed to run.

```
$ kubectl apply -f pod-root.yaml
Error from server (Forbidden): error when creating "pod-root.yaml": pods "root-user-container" is forbidden: violates PodSecurity "restricted:latest": runAsNonRoot != true (pod or container "secured-container" must set securityContext.runAsNonRoot=true)
```

The Pod defined by the YAML manifest `pod-privileged.yaml` runs the container with the user ID 1001 but requests priviliged mode.

```
$ kubectl apply -f pod-privileged.yaml
Error from server (Forbidden): error when creating "pod-privileged.yaml": pods "privileged-container" is forbidden: violates PodSecurity "restricted:latest": privileged (container "secured-container" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (container "secured-container" must set securityContext.allowPrivilegeEscalation=false)
```
