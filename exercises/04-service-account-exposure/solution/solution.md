# Solution

## Setting up the Objects

Start by creating the objects from the existing YAML manifest.

```
$ kubectl apply -f setup.yaml
namespace/k97 created
serviceaccount/sa-api created
clusterrole.rbac.authorization.k8s.io/operations-clusterrole created
clusterrolebinding.rbac.authorization.k8s.io/serviceaccount-operations-clusterrolebinding created
pod/pod-list created
pod/configmap-list created
```

The Pods created in the namespace `k97` should transition into the "Running" status.

```
$ kubectl get pods -n k97
NAME             READY   STATUS    RESTARTS   AGE
configmap-list   1/1     Running   0          32s
pod-list         1/1     Running   0          32s
```

## Checking the Pod Logs

The Pod named `configmap-list` makes a call to the API server to retrieve the list of ConfigMaps. The logs of the container should indicate a successful call.

```
$ kubectl logs configmap-list -n k97
[SUCCESS] Listing ConfigMaps...
...
```

The Pod named `pod-list` makes a call to the API server to retrieve the list of Pods. The logs of the container should indicate a successful call.

```
$ kubectl logs pod-list -n k97
[SUCCESS] Listing Pods...
...
```

## Reducing RBAC Permissions

Both Pods use a single service account named `sa-api`.

```
$ kubectl get pod configmap-list -n k97 -o jsonpath='{.spec.serviceAccountName}'
sa-api
$ kubectl get pod pod-list -n k97 -o jsonpath='{.spec.serviceAccountName}'
sa-api
```

This ClusterRoleBinding `serviceaccount-operations-clusterrolebinding` maps the service account to the RBAC permissions. It's not a good idea to define cluster-wide permissions on a wide range of API resources. It would be better to declare those permissions on the namespace-level while at the same time restricting the allowed permissions. Upon inspection of the ClusterRole `operations-clusterrole`, you will see that Secrets are included as well even though we didn't use it in the Pods. We should remove it from the list of API resources.

This can be achieved by creating the two new Roles and RoleBindings. Modify the setup script by deleting the existing ClusterRole and ClusterRoleBinding. Furthermore add the new Roles, RoleBindings, and service accounts. The resulting YAML manifest can be found [here](./setup.yaml).

## Applying the Changes

You cannot modify the the service account of an already running Pod. We'll need to delete the Pods first.

```
$ kubectl delete pod configmap-list -n k97
pod "configmap-list" deleted
$ kubectl delete pod pod-list -n k97
pod "pod-list" deleted
```

Now, apply the setup script in the `solution` folder or the one you modified.

```
$ kubectl apply -f setup.yaml
namespace/k97 unchanged
serviceaccount/sa-pod-api created
serviceaccount/sa-configmap-api created
role.rbac.authorization.k8s.io/pod-operations-clusterrole created
role.rbac.authorization.k8s.io/configmap-operations-clusterrole created
rolebinding.rbac.authorization.k8s.io/serviceaccount-pod-clusterrolebinding created
rolebinding.rbac.authorization.k8s.io/serviceaccount-configmap-clusterrolebinding created
pod/pod-list created
pod/configmap-list created
```

Make sure, you also delete the existing ClusterRole, ClusterRoleBinding, and ServiceAccount.

```
$ kubectl delete clusterrole operations-clusterrole
clusterrole.rbac.authorization.k8s.io "operations-clusterrole" deleted
$ kubectl delete clusterrolebinding serviceaccount-operations-clusterrolebinding
clusterrolebinding.rbac.authorization.k8s.io "serviceaccount-operations-clusterrolebinding" deleted
$ kubectl delete sa sa-api -n k97
serviceaccount "sa-api" deleted
```

The Pods should function as before. You can check by rendering the logs.

```
$ kubectl logs configmap-list -n k97
[SUCCESS] Listing ConfigMaps...
...
$ kubectl logs pod-list -n k97
[SUCCESS] Listing Pods...
```
