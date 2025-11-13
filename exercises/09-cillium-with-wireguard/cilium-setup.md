# Setting up Cilium

## Using Minikube

If you are using minikube, you will need to start the cluster with multiple worker nodes. The following command creates two worker nodes.

```
$ minikube start --nodes 3
```

The following commands use Helm to [install Cilium and configures it to use WireGuard](https://docs.cilium.io/en/latest/security/network/encryption-wireguard/#enable-wireguard-in-cilium).

```
$ helm repo add cilium https://helm.cilium.io/
$ helm repo update
$ helm install cilium cilium/cilium --namespace kube-system --set encryption.enabled=true --set encryption.type=wireguard --set encryption.nodeEncryption=true
```

Wait for Cilium to be ready.

```
$ kubectl -n kube-system wait --for=condition=ready pod -l app.kubernetes.io/name=cilium-agent --timeout=300s
```

You can check status of Cilium and WireGuard with the following commands.

```
$ kubectl -n kube-system exec -it ds/cilium -- cilium status
$ kubectl -n kube-system exec -it ds/cilium -- cilium encrypt status
```

## Using a Regular Kubernetes Cluster

You can install Cilium on any generic Kubernetes cluster with multiple worker nodes. The same commands apply as outlined above.
