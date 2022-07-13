# Solution

## Setting up the Pods

Start by creating the objects from the existing YAML manifest.

```
$ kubectl apply -f setup.yaml
namespace/r61 created
pod/backend created
pod/loop created
pod/logstash created
```

Wait until all Pods transition into the "Running" status.

```
$ kubectl get pods -n r61
NAME       READY   STATUS    RESTARTS   AGE
backend    1/1     Running   0          115s
logstash   1/1     Running   0          115s
loop       1/1     Running   0          115s
```

## Identifying Vulnerabilities

Check the images of each Pod in the namespace `r61` using the `kubectl describe` command. The used images are `bmuschko/nodejs-hello-world:1.0.0`, `alpine:3.13.4`, and `elastic/logstash:7.13.3`.

```
$ kubectl describe pod backend -n r61
...
Containers:
  hello:
    Container ID:   docker://eb0bdefc75e635d03b625140d1eb229ca2db7904e44787882147921c2bd9c365
    Image:          bmuschko/nodejs-hello-world:1.0.0
    ...
```

Use the Trivy executable to check vulnabilities for all images.

```
$ trivy image bmuschko/nodejs-hello-world:1.0.0
$ trivy image alpine:3.13.4
$ trivy image elastic/logstash:7.13.3
```

If you look closely add the list of vulnerabilites, you will find that all images contain issues with "CRITICAL" severity. As a result, delete all Pods.

```
$ kubectl delete pod backend -n r61
$ kubectl delete pod logstash -n r61
$ kubectl delete pod loop -n r61
```
