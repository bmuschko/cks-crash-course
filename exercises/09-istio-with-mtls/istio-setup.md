# Setting up Cilium

## Using Minikube

Add Istio Helm repository.

```
$ helm repo add istio https://istio-release.storage.googleapis.com/charts
$ helm repo update
```

Install Istio base components (CRDs and cluster-wide resources).

```
$ helm install istio-base istio/base --namespace istio-system --create-namespace --wait
```

Install Istio control plane (istiod).

```
$ helm install istiod istio/istiod --namespace istio-system --wait
```

Verify installation.

```
$ kubectl get pods -n istio-system
$ kubectl get services -n istio-system
```

Check istiod is ready.

```
$ kubectl wait --for=condition=ready pod -l app=istiod --timeout=300s -n istio-system
```

## Using a Regular Kubernetes Cluster

You can install Istio on any generic Kubernetes cluster. The same commands apply as outlined above.