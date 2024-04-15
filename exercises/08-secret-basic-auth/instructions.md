# Exercise 8

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `d31`<br>
* Documentation: [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)

</p>
</details>

A Pod needs username and password credentials for communicating with a third-party web service. Define a Secret for basic authentication and inject the credentials into the container as environment variables.

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Creating a Secret and Consuming It from a Pod"](https://learning.oreilly.com/scenarios/creating-a-secret/9781098149901/).

1. Create a new namespace named `d31`.
2. Define a Secret named `api-basic-auth` of type `kubernetes.io/basic-auth` in the namespace `d31`. Set the key value-pairs `username=api-creds` and `password=bhj123as`.
3. Create a Pod named `server-app` in the namespace `d31` with the image `nginx:1.18.0`. Inject the Secret credentials as environment variables. The keys should follow typical naming conventions for environment variables (all capital letters, underscore to separate words).
4. Verify that the environment variables are available inside of the container.