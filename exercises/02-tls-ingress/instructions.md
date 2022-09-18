# Exercise 2

You are tasked to create an Ingress with TLS termination. Create the relevant objects using the imperative or declarative approach.

> **_NOTE:_** Kubernetes requires running an Ingress Controller to evaluate Ingress rules. Make sure your cluster employs an [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/). You can find installation guidance in the file [ingress-controller-setup.md](./ingress-controller-setup.md).

1. Create the objects defined by the YAML manifest [`setup.yaml`](./setup.yaml). You will end up with a Deployment, multiple Pods, and a Service in the namespace `t75`.
2. Generate a TLS certificate and key using OpenSSL with the command `openssl req -nodes -new -x509 -keyout accounting.key -out accounting.crt -subj "/CN=accounting.tls"`.
3. Create a Secret named `accounting-secret` of type `kubernetes.io/tls` in the namespace `t75`. Use the TLS certificate and key from the previous step.
4. Create an Ingress named `accounting-ingress` in the namespace `t75`. Assign the Secret from the previous step to the host `accounting.internal.acme.com`. The Ingress is supposed to the route traffic to the Sevice named `accounting-secret` on port 80 for the path `/accounting` of type `Prefix`.