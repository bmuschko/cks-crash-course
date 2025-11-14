# Exercise 9

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `istio-test`<br>
* Documentation: [Mutual TLS with Istio](https://istio.io/latest/docs/concepts/security/#mutual-tls-authentication)

</p>
</details>

Istio is a service mesh that provides traffic management, security, and observability for microservices. One of its key security features is mutual TLS (mTLS), which provides strong service-to-service authentication and encryption. In this exercise, you will configure Istio to enable mTLS for secure communication between services.

> [!IMPORTANT]
> This exercise requires a cluster with Istio installed. You can find installation guidance in the file [istio-setup.md](./istio-setup.md).

1. Verify that Istio is installed and running in the cluster. Check the control plane components.
2. Create the namespace `istio-test` and enable automatic sidecar injection for Istio.
3. Create the two Pods and a Service in the namespace `istio-test` by applying the YAML manifest in [`setup.yaml`](./setup.yaml).
4. Verify that the Istio sidecar proxies have been injected into the Pods.
5. Configure a PeerAuthentication policy to enforce PERMISSIVE mTLS mode for all Pods in the namespace.
6. Test the Pod-to-Pod communication to ensure mTLS is working correctly.
7. Change the PeerAuthentication policy to enforce STRICT mTLS mode for the Service `pod1-svc` in the namespace.
8. Test the Pod-to-Service communication to ensure mTLS is working correctly.
