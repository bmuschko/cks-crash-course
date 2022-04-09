# Solution

## Setting up the Objects

Start by creating the objects from the existing YAML manifest.

```
$ kubectl apply -f setup.yaml
namespace/t75 created
deployment.apps/nginx-deployment created
service/nginx-service created
```

The objects create can be queried for. We create a Deployment named `nginx-deployment` with three replicas.

```
$ kubectl get all -n t75
NAME                                   READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-9456bbbf9-nlv6g   1/1     Running   0          18s
pod/nginx-deployment-9456bbbf9-wc2r4   1/1     Running   0          18s
pod/nginx-deployment-9456bbbf9-zq5zc   1/1     Running   0          18s

NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/nginx-service   ClusterIP   10.106.136.234   <none>        80/TCP    18s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   3/3     3            3           18s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-9456bbbf9   3         3         3       18s
```

## Creating the Secret

Run the OpenSSL command to generate the TLS certificate and key.

```
$ openssl req -nodes -new -x509 -keyout accounting.key -out accounting.crt -subj "/CN=accounting.tls"
Generating a 2048 bit RSA private key
...........................+++
..........................+++
writing new private key to 'accounting.key'
-----
```

The easiest way to create a Secret is with the help of an imperative command. This method of creation doesn't require base64-encoding the certificate and key values to. It happens automatically.

```
$ kubectl create secret tls accounting-secret --cert=accounting.crt --key=accounting.key -n t75
secret/accounting-secret created
```

## Creating the Ingress

Use the imperative method to create the Ingress with the help of a one-liner.

```
$ kubectl create ingress accounting-ingress --rule="accounting.internal.acme.com/accounting=accounting-service:80,tls=accounting-secret" -n t75
ingress.networking.k8s.io/accounting-ingress created
```

The resulting YAML manifest looks as such:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: accounting-ingress
  namespace: t75
spec:
  tls:
  - hosts:
      - accounting.internal.acme.com
    secretName: accounting-secret
  rules:
  - host: accounting.internal.acme.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: accounting-service
            port:
              number: 80
```

The resulting Ingress object should be available in the namespace.

```
$ kubectl get ingress -n t75
NAME                 CLASS    HOSTS                          ADDRESS   PORTS     AGE
accounting-ingress   <none>   accounting.internal.acme.com             80, 443   2m1s
```