# Solution

## Setting up the Objects

Start by creating the objects from the existing YAML manifest.

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

## Enable the Admission Controller Plugin

If you are on Linux, you can edit the file `vim /etc/kubernetes/manifests/kube-apiserver.yaml`. Add the value `PodSecurityPolicy` to the parameter `--enable-admission-plugins`.

```
$ vim /etc/kubernetes/manifests/kube-apiserver.yaml
...
spec:
  containers:
  - command:
    - kube-apiserver
    - ...
    - --enable-admission-plugins=NodeRestriction,PodSecurityPolicy
```

Editing the configuration of the API server will automatically restart the Pod(s). Wait until the node comes back up. You may receive connection errors from the API server if you query for it with `kubectl get nodes`.

To enable the plugin on Minikube, execute the following command:

```
$ minikube addons enable pod-security-policy
🌟  The 'pod-security-policy' addon is enabled
```

## Creating the Pod Security Policy

Create the Pod Security Policy named `psp-non-root-user` in the YAML manifest file `psp-non-root-user.yaml`. The setting that defines that only non-root user can run the container is `.spec.runAsUser.rule`. For more information, see the [documentation](https://kubernetes.io/docs/concepts/security/pod-security-policy/#users-and-groups).

```yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: psp-non-root-user
spec:
  runAsUser:
    rule: 'MustRunAsNonRoot'
  fsGroup:
    rule: RunAsAny
  supplementalGroups:
    rule: RunAsAny
  seLinux:
    rule: RunAsAny
```

Create the object.

```
$ kubectl apply -f psp-non-root-user.yaml
Warning: policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
podsecuritypolicy.policy/psp-non-root-user created
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

Define a YAML manifest for the ClusterRoleBinding in the file named `psp-rolebinding.yaml`.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: psp-rolebinding
  namespace: k29
roleRef:
  kind: ClusterRole
  name: psp-clusterrole
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: Group
  apiGroup: rbac.authorization.k8s.io
  name: system:serviceaccounts:sa-gov
```

Create the object.

```
$ kubectl apply -f psp-rolebinding.yaml
rolebinding.rbac.authorization.k8s.io/psp-rolebinding created
```

## Enforcing the Behavior

```
$ kubectl apply -f pod-non-root.yaml
pod/non-root-user-container created
```

```
$ kubectl apply -f pod-root.yaml
pod/root-user-container created
```