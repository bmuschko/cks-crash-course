# Configuring the Pod Security Policy Admission Controller

## Using Minikube

The [minikube documentation](https://minikube.sigs.k8s.io/docs/tutorials/using_psp/) explains how to configure the Pod Security Policy Admission Controller. Even though I followed the instructions, I could personally not get this to work. Let me know if you can make it work for you and I'd happily update the instructions.

## Using a Regular Kubernetes Cluster

If you are on Linux, you can edit the file `/etc/kubernetes/manifests/kube-apiserver.yaml` on the control plane node. Add the value `PodSecurityPolicy` to the parameter `--enable-admission-plugins`.

```
$ sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
...
spec:
  containers:
  - command:
    - kube-apiserver
    - ...
    - --enable-admission-plugins=NodeRestriction,PodSecurityPolicy
```

Editing the configuration of the API server will automatically restart the Pod(s). Wait until the node comes back up. You may receive connection errors from the API server if you query for it with `kubectl get nodes`, e.g. the following:

```
$ kubectl get nodes
The connection to the server 192.168.56.10:6443 was refused - did you specify the right host or port?
```

After a little while, the cluster will be functional again.

```
vagrant@kube-control-plane:~$ kubectl get nodes
NAME                 STATUS   ROLES                  AGE     VERSION
kube-control-plane   Ready    control-plane,master   5m31s   v1.23.6
kube-worker-1        Ready    <none>                 3m57s   v1.23.6 
```