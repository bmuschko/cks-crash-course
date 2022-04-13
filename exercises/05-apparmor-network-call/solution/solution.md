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

On the `kube-worker-1` node, create the AppArmor profile at `/etc/apparmor.d/network-deny`.

```
#include <tunables/global>

profile k8s-deny-write flags=(attach_disconnected) {
  #include <abstractions/base>

  network,
}
```

Enforce the AppArmor profile by running the following command.

```
$ sudo apparmor_parser /etc/apparmor.d/network-deny
```

Modify the existing live Pod object. Add the annotation for AppArmor. Use the name of the container `alpine` as part of the key suffix. Use `localhost/network-deny` as the value. The suffix `network-deny` refers to the name of the AppArmor profile.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: network-call
  annotations:
    container.apparmor.security.beta.kubernetes.io/alpine: localhost/network-deny
spec:
  containers:
  - name: alpine
    image: alpine/curl:3.14
    command: [ "sh", "-c", "while true; do ping -c 1 google.com; sleep 5; done" ]
```