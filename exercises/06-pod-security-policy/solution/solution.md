# Solution

## Setting up the Objects

Start by creating the objects from the existing YAML manifest named [`setup.yaml`](./setup.yaml). Copy the contents to the VM and apply it YAML manifest.

```
$ kubectl apply -f setup.yaml
namespace/k29 created
serviceaccount/sa-gov created
```

The service account object create can be queried for.

```
$ kubectl get sa -n k29
NAME      SECRETS   AGE
sa-gov    1         44s
```

## Creating the Pod Security Policy

Create the Pod Security Policy named `psp-non-root-user-non-privileged` in the YAML manifest file `psp-non-root-user-non-privileged.yaml`. The setting that defines that only non-root user can run the container is `spec.runAsUser.rule`. The setting that requires privileged mode is `spec.privileged`. For more information, see the [documentation](https://kubernetes.io/docs/concepts/security/pod-security-policy/#users-and-groups).

```yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: psp-non-root-user-non-privileged
spec:
  privileged: false
  runAsUser:
    rule: 'MustRunAsNonRoot'
  fsGroup:
    rule: RunAsAny
  supplementalGroups:
    rule: RunAsAny
  seLinux:
    rule: RunAsAny
  volumes:
  - '*'
```

Create the object. The deprecation message is to be expected.

```
$ kubectl apply -f psp-non-root-user-non-privileged.yaml
Warning: policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
podsecuritypolicy.policy/psp-non-root-user-non-privileged created
```

## Creating RBAC Objects

Define a YAML manifest for the ClusterRole in a file named `psp-clusterrole.yaml`.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: psp-clusterrole
rules:
- apiGroups: ['policy']
  resources: ['podsecuritypolicies']
  verbs:     ['use']
  resourceNames:
  - psp-non-root-user
```

Create the object.

```
$ kubectl apply -f psp-clusterrole.yaml
clusterrole.rbac.authorization.k8s.io/psp-clusterrole created
```

Define a YAML manifest for the ClusterRoleBinding in the file named `psp-clusterrolebinding.yaml`.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: psp-clusterrolebinding
roleRef:
  kind: ClusterRole
  name: psp-clusterrole
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: Group
  apiGroup: rbac.authorization.k8s.io
  name: system:serviceaccounts:k29
```

Create the object.

```
$ kubectl apply -f psp-clusterrolebinding.yaml
clusterrolebinding.rbac.authorization.k8s.io/psp-clusterrolebinding created
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
pod/root-user-container created
$ kubectl get pods -n k29
NAME                      READY   STATUS                       RESTARTS   AGE
non-root-user-container   1/1     Running                      0          54s
root-user-container       0/1     CreateContainerConfigError   0          12s
$ kubectl describe pod root-user-container -n k29
...
Events:
  Type     Reason          Age                   From               Message
  ----     ------          ----                  ----               -------
  ...
  Warning  Failed          105s (x11 over 3m7s)  kubelet            Error: container has runAsNonRoot and image will run as root (pod: "root-user-container_k29(1698ee59-7ecd-4cf9-9e38-c183cfc27434)", container: secured-container)
```

The Pod defined by the YAML manifest `pod-privileged.yaml` runs the container with the user ID 1001 but requests priviliged mode.

```
$ kubectl apply -f pod-privileged.yaml
Error from server (Forbidden): error when creating "pod-privileged.yaml": pods "privileged-container" is forbidden: PodSecurityPolicy: unable to admit pod: [spec.containers[0].securityContext.privileged: Invalid value: true: Privileged containers are not allowed]
```
