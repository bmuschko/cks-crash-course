# Solution

## Setting up the Pods

Start by creating the objects from the existing YAML manifest.

```
$ kubectl apply -f setup.yaml
namespace/g04 created
pod/backend created
pod/frontend created
pod/other created
```

The namespace `g04` runs the following Pods. Use the `-o wide` CLI option to determine the virtual IP addresses assigned to the Pods.

```
$ kubectl get pods -n g04 -o wide
NAME       READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
backend    1/1     Running   0          15s   10.0.0.43    minikube   <none>           <none>
frontend   1/1     Running   0          15s   10.0.0.193   minikube   <none>           <none>
```

The `default` namespace handles a single Pod.

```
$ kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
other   1/1     Running   0          4h45m
```

The `frontend` Pod can talk to the `backend` Pod as no communication restrictions have been put in place.

```
$ kubectl exec frontend -it -n g04 -- /bin/sh
/ # wget --spider --timeout=1 10.0.0.43:3000
Connecting to 10.0.0.43:3000 (10.0.0.43:3000)
remote file exists
/ # exit
```

The `other` Pod residing in the `default` namespace can communicate with the `backend` Pod without problems.

```
$ kubectl exec other -it -- /bin/sh
/ # wget --spider --timeout=1 10.0.0.43:3000
Connecting to 10.0.0.43:3000 (10.0.0.43:3000)
remote file exists
/ # exit
```

## Instating the "deny-all-ingress" network policy

Create a ["deny-all-ingress" network policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/#default-deny-all-ingress-traffic) for the `g04` namespace in the form of a YAML manifest, as shown below.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: g04
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

The contents of the "deny-all" network policy has been saved in the file `deny-all-ingress-network-policy.yaml`. Create the object from the file.

```
$ kubectl apply -f deny-all-ingress-network-policy.yaml
networkpolicy.networking.k8s.io/default-deny-ingress created
```

The `frontend` cannot talk to the `backend` Pod anymore, as observed by running the same `wget` command as before.

```
$ kubectl exec frontend -it -n g04 -- /bin/sh
/ # wget --spider --timeout=1 10.0.0.43:3000
Connecting to 10.0.0.43:3000 (10.0.0.43:3000)
wget: download timed out
/ # exit
```

Furthermore, Pods running in a different namespace cannot connect to the `backend` Pod either.

```
$ kubectl exec other -it -- /bin/sh
/ # wget --spider --timeout=1 10.0.0.43:3000
Connecting to 10.0.0.43:3000 (10.0.0.43:3000)
wget: download timed out
```

## Allowing traffic within the g04 namespace

Identify the labels of the `g04` namespace and the Pods running in the namespace.

```
$ kubectl get ns g04 --show-labels
NAME   STATUS   AGE   LABELS
g04    Active   12m   app=orion,kubernetes.io/metadata.name=g04
$ kubectl get pods -n g04 --show-labels
NAME       READY   STATUS    RESTARTS   AGE     LABELS
backend    1/1     Running   0          9m46s   tier=backend
frontend   1/1     Running   0          9m46s   tier=frontend
```

Create a new network policy that allows the `frontend` Pod to talk to the `backend` Pod on port 3000 only. No other communication should be allowed. The YAML manifest representation could look as follows.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-ingress
  namespace: g04
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          app: orion
      podSelector:
        matchLabels:
          tier: frontend
    ports:
    - protocol: TCP
      port: 3000
```

The definition of the network policy has been stored in the file `backend-ingress-network-policy.yaml`. Create the object from the file.

```
$ kubectl apply -f backend-ingress-network-policy.yaml
networkpolicy.networking.k8s.io/backend-ingress created
```

The `frontend` Pod can now talk to the `backend` Pod.

```
$ kubectl exec frontend -it -n g04 -- /bin/sh
/ # wget --spider --timeout=1 10.0.0.43:3000
Connecting to 10.0.0.43:3000 (10.0.0.43:3000)
remote file exists
/ # exit
```

Pods outside of the `g04` namespace still can't connect to the `backend` Pod.

```
$ kubectl exec other -it -- /bin/sh
/ # wget --spider --timeout=1 10.0.0.43:3000
Connecting to 10.0.0.43:3000 (10.0.0.43:3000)
wget: download timed out
```
