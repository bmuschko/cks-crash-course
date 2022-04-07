Start by creating the objects from the existing YAML manifest.

```
$ kubectl apply -f setup.yaml
namespace/g04 created
pod/backend created
pod/frontend created
pod/nginx created
```

The namespace `g04` runs the following Pods. Use the `-o wide` CLI option to determine the virtual IP addresses assigned to the Pods.

```
$ kubectl get pods -n g04 -o wide
NAME       READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
backend    1/1     Running   0          5h12m   172.17.0.5   minikube   <none>           <none>
frontend   1/1     Running   0          5h12m   172.17.0.6   minikube   <none>           <none>
```

The `default` namespace handles a single Pod.

```
$ kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          4h45m
```

The `frontend` Pod can talk to the `backend` Pod as no communication restrictions have been set up.

```
$ kubectl exec frontend -it -n g04 -- /bin/sh
/ # wget 172.17.0.5:3000
Connecting to 172.17.0.5:3000 (172.17.0.5:3000)
saving to 'index.html'
index.html           100% |************************************************************************|    12  0:00:00 ETA
'index.html' saved
/ # exit
```

Create a ["deny-all" network policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/#default-deny-all-ingress-and-all-egress-traffic) for the `g04` namespace in the form of a YAML manifest, as shown below.

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: g04
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

The contents of the "deny-all" network policy has been saved in the file `deny-all-network-policy.yaml`. Create the object from the file.

```
$ kubectl apply -f deny-all-network-policy.yaml
networkpolicy.networking.k8s.io/default-deny-all created
```

The `frontend` cannot talk to the `backend` Pod anymore, as observed by running the same `wget` command as before.

```
$ kubectl exec frontend -it -n g04 -- /bin/sh
/ # wget 172.17.0.5:3000
Connecting to 172.17.0.5:3000 (172.17.0.5:3000)
wget: can't open 'index.html': File exists
/ # exit
```