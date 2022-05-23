# Solution

## Setting up the Pods

Start by creating the objects from the existing YAML manifest.

```
$ kubectl apply -f setup.yaml
namespace/h92 created
pod/loop created
pod/nginx created
pod/hello-world created
pod/busybox created
```

List all Pods in the namespace `h92`.

```
$ kubectl get pods -n h92
NAME          READY   STATUS      RESTARTS   AGE
busybox       0/1     Completed   0          14s
hello-world   0/1     Completed   0          14s
loop          1/1     Running     0          14s
nginx         1/1     Running     0          14s
```

## Identifying Pods with Mutable Containers

You can inspect the configuration of the live objects using the `kubectl get pod` command with the option `-o yaml`. For example, to inspect the configuration of the `busybox` Pod, run the command `kubectl get pod busybox -n h92 -o yaml`.

The following table explains why a specific Pod is immutable or mutable.

| Pod             | Mutability  | Reason |
| :-------------- | :---------- | :----- |
| `busybox`       | mutable     | The container uses `hostNetwork` with the value `true`. |
| `hello-world`   | mutable     | The container uses `securityContext.runAsUser` with the value `0`. |
| `loop`          | mutable     | The container uses `securityContext.privileged` with the value `true`. |
| `nginx`         | immutable   | The container uses `securityContext.readOnlyRootFilesystem` with the value `true`. Directories required by nginx have been mounted as Volumes. |

## Deleting Mutable Pods

Delete the Pods that define mutable containers.

```
$ kubectl delete pod busybox -n h92
pod "busybox" deleted
$ kubectl delete pod hello-world -n h92
pod "hello-world" deleted
$ kubectl delete pod loop -n h92
pod "loop" deleted
```

You should be left with a single Pod.

```
$ kubectl get pods -n h92
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          41m
```