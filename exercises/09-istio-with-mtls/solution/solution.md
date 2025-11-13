# Solution

## Enabling Automatic Sidecar Injection

Create new namespace for Istio tests.

```
$ kubectl create namespace istio-test
namespace/istio-test created
```

When you set the `istio-injection=enabled` label on a namespace and the injection webhook is enabled, any new Pods that are created in that namespace will automatically have a sidecar added to them. Enable [automatic sidecar injection](https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/#automatic-sidecar-injection) for the `istio-test` namespace.

```
$ kubectl label namespace istio-test istio-injection=enabled
namespace/istio-test labeled
```

Verify label.

```
$ kubectl get namespace istio-test --show-labels
NAME         STATUS   AGE   LABELS
istio-test   Active   19s   istio-injection=enabled,kubernetes.io/metadata.name=istio-test
```

## Deploying Test Applications

Use the `setup.yaml` file to create the test applications. Apply the YAML manifest will deploy the Pod `pod1`, a simple HTTP testing service, and the Pod `pod2`, a curl client. It will also create a Service for Pod `pod1`.

```
$ kubectl apply -f setup.yaml
pod/pod1 created
pod/pod2 created
service/pod1-svc created
```

Wait for Pods to be ready (should show 2/2 containers due to sidecars).

```
$ kubectl wait --for=condition=ready pod/pod1 --timeout=300s -n istio-test
pod/pod1 condition met
$ kubectl wait --for=condition=ready pod/pod2 --timeout=300s -n istio-test
pod/pod2 condition met
```

Verify that the sidecars were injected.

```
$ kubectl get pods -n istio-test
NAME   READY   STATUS    RESTARTS   AGE
pod1   2/2     Running   0          3m19s
pod2   2/2     Running   0          3m18s
```

Make sure that the Service exists.

```
kubectl get services -n istio-test
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
pod1-svc   ClusterIP   10.102.238.13   <none>        80/TCP    7m3s
```

## Configure mTLS in PERMISSIVE Mode

You can find most of the information in Istio documentation page named [Mutual TLS Migration](https://istio.io/latest/docs/tasks/security/authentication/mtls-migration/). Start with PERMISSIVE mode (accepts both encrypted and plain text). Create the following content in the file _mtls-peerauthentication.yaml_.

```
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-test
spec:
  mtls:
    mode: PERMISSIVE
```

Create the object.

```
$ kubectl apply -f mtls-peerauthentication.yaml
peerauthentication.security.istio.io/default created
```

Test connectivity using the Pod's IP address. Determine the IP address of Pod `pod1`. Make a call from Pod `pod2` via curl by targetting the IP address.

```
$ kubectl -n istio-test get pod pod1 -o jsonpath='{.status.podIP}'
10.244.0.5
$ kubectl -n istio-test exec -ti pod2 -c sleep -- curl 10.244.0.5
...
```

## Configure mTLS in STRICT Mode

Change the PeerAuthentication object to use STRICT mode (only accept encrypted communication). Modify the content in the file _mtls-peerauthentication.yaml_.

```
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-test
spec:
  mtls:
    mode: STRICT
```

Apply the changes to the existing object.

```
$ kubectl apply -f mtls-permissive.yaml
peerauthentication.security.istio.io/default configured
```

Define a DestinationRule in the file _mtls-destinationrule.yaml_ that uses service discovery for the host name.

```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: pod1-svc-dr
  namespace: istio-test
spec:
  host: pod1-svc.istio-test.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
```

Test connectivity using the Services DNS name.

```
$ kubectl exec -it pod2 -c sleep -n istio-test -- curl http://pod1-svc/headers
{
  "headers": {
    "Accept": "*/*",
    "Host": "pod1-svc",
    "User-Agent": "curl/8.17.0",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/istio-test/sa/default;Hash=de5702f4b875cff45e5d3c1923523c7462a61c497527f51bc08c0e4925d19d0e;Subject=\"\";URI=spiffe://cluster.local/ns/istio-test/sa/default"
  }
}
```