# Solution

## Preparing the Cluster

Get your node names first.

```
$ kubectl get nodes
NAME           STATUS   ROLES           AGE   VERSION
minikube       Ready    control-plane   24m   v1.29.2
minikube-m02   Ready    <none>          23m   v1.29.2
minikube-m03   Ready    <none>          23m   v1.29.2
```

Label the nodes (replace minikube-m02 and minikube-m03 with your actual node names).

```
$ kubectl label node minikube-m02 node-role=node1
node/minikube-m02 labeled
$ kubectl label node minikube-m03 node-role=node2
node/minikube-m03 labeled
```

Verify the assigned labels.

```
$ kubectl get nodes --show-labels | grep node-role
minikube       Ready    control-plane   25m   v1.29.2   beta.kubernetes.io/arch=arm64,beta.kubernetes.io/os=linux,kubernetes.io/arch=arm64,kubernetes.io/hostname=minikube,kubernetes.io/os=linux,minikube.k8s.io/commit=dd5d320e41b5451cdf3c01891bc4e13d189586ed-dirty,minikube.k8s.io/name=minikube,minikube.k8s.io/primary=true,minikube.k8s.io/updated_at=2025_11_12T15_45_03_0700,minikube.k8s.io/version=v1.35.0,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
minikube-m02   Ready    <none>          25m   v1.29.2   beta.kubernetes.io/arch=arm64,beta.kubernetes.io/os=linux,kubernetes.io/arch=arm64,kubernetes.io/hostname=minikube-m02,kubernetes.io/os=linux,minikube.k8s.io/commit=dd5d320e41b5451cdf3c01891bc4e13d189586ed-dirty,minikube.k8s.io/name=minikube,minikube.k8s.io/primary=false,minikube.k8s.io/updated_at=2025_11_12T15_45_18_0700,minikube.k8s.io/version=v1.35.0,node-role=node1
minikube-m03   Ready    <none>          25m   v1.29.2   beta.kubernetes.io/arch=arm64,beta.kubernetes.io/os=linux,kubernetes.io/arch=arm64,kubernetes.io/hostname=minikube-m03,kubernetes.io/os=linux,minikube.k8s.io/commit=dd5d320e41b5451cdf3c01891bc4e13d189586ed-dirty,minikube.k8s.io/name=minikube,minikube.k8s.io/primary=false,minikube.k8s.io/updated_at=2025_11_12T15_45_26_0700,minikube.k8s.io/version=v1.35.0,node-role=node2
```

## Verifying WireGuard Encryption

Validate the setup in a new terminal window based on the instructions provided in the [Cillium documentation](https://docs.cilium.io/en/latest/security/network/encryption-wireguard/#validate-the-setup).

```
$ kubectl -n kube-system exec -it ds/cilium -- bash
root@minikube-m02:/home/cilium# cilium-dbg status | grep Encryption
Encryption:              Wireguard       [NodeEncryption: Enabled, cilium_wg0 (Pubkey: PWGkTtdk8oqKoOKAFs69CPBIC2qKcsga+RJ8/xSpNFs=, Port: 51871, Peers: 2)]
root@minikube-m02:/home/cilium# apt-get update
root@minikube-m02:/home/cilium# apt-get -y install tcpdump
root@minikube-m02:/home/cilium# tcpdump -n -i cilium_wg0
...
```

## Scheduling the Pods

Schedule the Pods on the nodes.

```
$ kubectl apply -f setup.yaml
namespace/encryption-test created
pod/pod1 created
pod/pod2 created
```

## Testing Encrypted Communication

Verify that the Pods are running on different nodes.

```
$ kubectl -n encryption-test get pods -o wide
NAME   READY   STATUS    RESTARTS   AGE   IP          NODE           NOMINATED NODE   READINESS GATES
pod1   1/1     Running   0          15s   10.0.0.60   minikube-m02   <none>           <none>
pod2   1/1     Running   0          15s   10.0.2.99   minikube-m03   <none>           <none>
```

Get `pod1`'s IP address and test connectivity from `pod2` to `pod1`.

```
$ kubectl -n encryption-test get pod pod1 -o jsonpath='{.status.podIP}'
10.0.0.60
$ kubectl -n encryption-test exec -it pod2 -- curl 10.0.0.60
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

You should also see encrypted calls via the `cilium_wg0` tunnel device in the other terminal window.

## Creating a Cillium Encryption Policy

Create a policy to enforce encryption for specific Pods in the file _cillium-network-policy.yaml_.

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: allow-pod2-to-pod1
  namespace: encryption-test
spec:
  endpointSelector:
    matchLabels:
      app: pod1
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: pod2
```

Apply the YAML manifest.

```
$ kubectl apply -f cillium-network-policy.yaml
ciliumnetworkpolicy.cilium.io/allow-pod2-to-pod1 created
```

Verify that the policy is applied.

```
$ kubectl -n kube-system exec -ti ds/cilium -- cilium policy get
[
  {
    "endpointSelector": {
      "matchLabels": {
        "any:app": "pod1",
        "k8s:io.kubernetes.pod.namespace": "encryption-test"
      }
    },
    "ingress": [
      {
        "fromEndpoints": [
          {
            "matchLabels": {
              "any:app": "pod2",
              "k8s:io.kubernetes.pod.namespace": "encryption-test"
            }
          }
        ]
      }
    ],
    "labels": [
      {
        "key": "io.cilium.k8s.policy.derived-from",
        "value": "CiliumNetworkPolicy",
        "source": "k8s"
      },
      {
        "key": "io.cilium.k8s.policy.name",
        "value": "allow-pod2-to-pod1",
        "source": "k8s"
      },
      {
        "key": "io.cilium.k8s.policy.namespace",
        "value": "encryption-test",
        "source": "k8s"
      },
      {
        "key": "io.cilium.k8s.policy.uid",
        "value": "a26780a2-90e0-4f22-9e96-f49298de959a",
        "source": "k8s"
      }
    ],
    "enableDefaultDeny": {
      "ingress": true,
      "egress": false
    }
  }
]
Revision: 2
```

You should still be able to make a call from pod2 to pod1.

```
$ kubectl -n encryption-test exec -it pod2 -- curl 10.0.0.60
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
```