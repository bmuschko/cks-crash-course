# Solution

## Setting up Cilium

If you are using Minikube, you will need to use the following command line options when starting the cluster. This will prepare the cluster for the installation of Cilium.

```
$ minikube start --network-plugin=cni --cni=false
```

The following commands to download Cilium for use with Minikube on MacOSX.

```
$ curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-darwin-amd64.tar.gz{,.sha256sum}
$ shasum -a 256 -c cilium-darwin-amd64.tar.gz.sha256sum
$ sudo tar xzvfC cilium-darwin-amd64.tar.gz /usr/local/bin
$ rm cilium-darwin-amd64.tar.gz{,.sha256sum}
```

Install Cilium with the following command.

```
$ cilium install
🔮 Auto-detected Kubernetes kind: minikube
✨ Running "minikube" validation checks
✅ Detected minikube version "1.24.0"
ℹ️  using Cilium version "v1.10.11"
🔮 Auto-detected cluster name: minikube
🔮 Auto-detected IPAM mode: cluster-pool
🔮 Auto-detected datapath mode: tunnel
🔑 Created CA in secret cilium-ca
🔑 Generating certificates for Hubble...
🚀 Creating Service accounts...
🚀 Creating Cluster roles...
🚀 Creating ConfigMap for Cilium version 1.10.11...
🚀 Creating Agent DaemonSet...
🚀 Creating Operator Deployment...
⌛ Waiting for Cilium to be installed and ready...
♻️  Restarting unmanaged pods...
♻️  Restarted unmanaged pod default/other
♻️  Restarted unmanaged pod g04/backend
♻️  Restarted unmanaged pod g04/frontend
✅ Cilium was successfully installed! Run 'cilium status' to view installation health
```

Refer to the [Cilium documentation](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/) for installing Cilium on all other platforms.

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

```
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

```
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