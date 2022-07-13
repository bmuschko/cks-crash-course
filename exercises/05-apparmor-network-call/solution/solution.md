# Solution

Before creating and enforcing the AppArmor profile, check the logs of the Pod `network-call`. The Pod run a `ping` command every 5 seconds. The command should be successful.

```
$ kubectl logs network-call
PING google.com (172.217.18.110): 56 data bytes
64 bytes from 172.217.18.110: icmp_seq=0 ttl=119 time=31.155 ms

--- google.com ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 31.155/31.155/31.155/0.000 ms
```

Create the AppArmor profile at `/etc/apparmor.d/network-deny` using the command `sudo vim /etc/apparmor.d/network-deny`. The contents of the file could look as follows.

```
#include <tunables/global>

profile network-deny flags=(attach_disconnected) {
  #include <abstractions/base>

  network,
}
```

Enforce the AppArmor profile by running the following command.

```
$ sudo apparmor_parser /etc/apparmor.d/network-deny
```

You cannot modify the existing Pod object in order to add the annotation for AppArmor. You will need to delete the object first. Write the definition of the Pod to a file.

```
$ kubectl get pod -o yaml > pod.yaml
$ kubectl delete pod network-call
pod "network-call" deleted
```

Edit the `pod.yaml` file to add the AppArmor annotation. For the relevant annotation, use the name of the container `network-call` as part of the key suffix and `localhost/network-deny` as the value. The suffix `network-deny` refers to the name of the AppArmor profile. The final content could look as follows:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: network-call
  annotations:
    container.apparmor.security.beta.kubernetes.io/network-call: localhost/network-deny
spec:
  containers:
  - name: network-call
    image: alpine/curl:3.14
    command: ["sh", "-c", "while true; do ping -c 1 google.com; sleep 5; done"]
```

Create the Pod from the manifest. You will see that the status is "Blocked". The reason for this status is that the AppArmor profile does not exist on the worker node. That's where the Kubernetes scheduler wants to run the Pod.

```
$ kubectl create -f pod.yaml
pod/network-call created
$ kubectl get pod network-call
NAME           READY   STATUS    RESTARTS   AGE
network-call   0/1     Blocked   0          22s
```

Exit out of the control plane node and SSH into the worker node. Create the AppArmor profile at `/etc/apparmor.d/network-deny` using the command `sudo vim /etc/apparmor.d/network-deny`. The contents of the file could look as follows.

```
#include <tunables/global>

profile network-deny flags=(attach_disconnected) {
  #include <abstractions/base>

  network,
}
```

Enforce the AppArmor profile by running the following command.

```
$ sudo apparmor_parser /etc/apparmor.d/network-deny
```

After a couple of seconds, the Pod should transition into the "Running" status.

```
$ kubectl get pod network-call
NAME           READY   STATUS    RESTARTS   AGE
network-call   1/1     Running   0          27s
```

AppArmor prevents the Pod from making a network call. You can check the logs to verify.

```
$ kubectl logs network-call
...
sh: ping: Permission denied
sh: sleep: Permission denied
```