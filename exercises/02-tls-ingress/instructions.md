# Exercise 2

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `t75`<br>
* Documentation: [Ingresses](https://kubernetes.io/docs/concepts/services-networking/ingress/), [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

</p>
</details>

You are tasked to create an Ingress with TLS termination. Create the relevant objects using the imperative or declarative approach.

> [!IMPORTANT]
> Kubernetes requires running an Ingress Controller to evaluate Ingress rules. Make sure your cluster employs an [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/). You can find installation guidance in the file [ingress-controller-setup.md](./ingress-controller-setup.md). If you are using minikube, the network is limited if using the Docker driver on Darwin, Windows, or WSL, and the Node IP is not reachable directly. Refer to the [documentation](https://minikube.sigs.k8s.io/docs/handbook/accessing/) to gain access to the minikube IP.

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Configuring TLS Termination for an Ingress"](https://learning.oreilly.com/scenarios/configuring-tls-termination/9781098149666/).

1. Create the objects defined by the YAML manifest [`setup.yaml`](./setup.yaml). You will end up with a Deployment, multiple Pods, and a Service in the namespace `t75`.
2. Generate a TLS certificate and key using OpenSSL with the command `openssl req -nodes -new -x509 -keyout accounting.key -out accounting.crt -subj "/CN=accounting.tls"`.
3. Create a Secret named `accounting-secret` of type `kubernetes.io/tls` in the namespace `t75`. Use the TLS certificate and key from the previous step.
4. Create an Ingress named `accounting-ingress` in the namespace `t75`. Assign the Secret from the previous step to the host `accounting.internal.acme.com`. The Ingress is supposed to the route traffic to the Service named `accounting-service` on port 80 for the path `/accounting` of type `Prefix`.
