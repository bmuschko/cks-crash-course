# Excerise 7

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `default`<br>
* Documentation: [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeper)

</p>
</details>

Your organization decides to introduce and enforce policies for Pods. You will create an Object Policy Agent (OPA) constraint and then verify the correct enforcement.

> [!NOTE]
> If you do not already have a cluster, you can create one by using minikube or you can use the O'Reilly interactive lab ["Governing Object Creation with OPA Gatekeeper"](https://learning.oreilly.com/scenarios/governing-object-creation/9781098149888/).

1. Install the OPA gatekeeper objects with the version 3.7. Refer to the [OPA gatekeeper installation documentation](https://open-policy-agent.github.io/gatekeeper/website/docs/install/).
2. Ensure that the OPA gatekeeper objects transition into the "Running" status.
3. Inspect the OPA constraint template in the already existing file [`opa-constraint-template-annotation.yaml`](opa-constraint-template-annotation.yaml). Create the object.
4. Create an OPA constraint object for Deployments that requires two annotations to be specified with the keys `contact` and `commit-hash`.
5. Create a Deployment that does not define the annotations. What's the behavior?
6. Create a Deployment that does define the annotations. What's the behavior?
7. Delete the OPA gatekeeper objects.
