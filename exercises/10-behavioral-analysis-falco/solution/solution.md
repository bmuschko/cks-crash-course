# Solution

Open an interactive shell into the cluster node named `kube-worker-1`:

```
$ vagrant ssh kube-worker-1
```

Check the status of the existing Pod. The output of the command should indicate the existence of the Pod. Wait until the Pod transitions into the "Running" status.

```
$ kubectl get pod malicious
NAME        READY   STATUS    RESTARTS   AGE
malicious   1/1     Running   0          13s
```

Inspect the command and arguments of the running Pod named `malicious`. You will see that it tries to append a message to the file `/etc/threat`.

```
$ kubectl get pod malicious -o jsonpath='{.spec.containers[0].args}'
["/bin/sh","-c","while true; do echo 'attacker intrusion' \u003e\u003e /etc/threat; sleep 5; done"]
```

One of Falco’s default rules monitors file operations that try to write to the `/etc` directory. You can find a message for every write attempt in standard output.

```
$ sudo journalctl -fu falco
Apr 09 15:23:07 kube-worker-1 falco[17603]: 15:23:07.676235231: Error File below /etc opened for writing (user=root user_loginuid=-1 command=sh -c while true; do echo 'attacker intrusion' >> /etc/threat; sleep 5; done pid=13920 parent=containerd-shim pcmdline=containerd-shim -namespace moby -id e900d9ed474a8409241949b48011e7e0fadde7a83cda08cd7386f1a3ae1f5553 -address /run/containerd/containerd.sock file=/etc/threat program=sh gparent=systemd ggparent=<NA> gggparent=<NA> container_id=e900d9ed474a image=alpine)
...
```

Stop the running command with `CTRL + C`.

Find the rule that produces the message in `/etc/falco/falco_rules.yaml` by searching for the string "etc opened for writing". The rule looks as follows.

```yaml
- rule: Write below etc
  desc: an attempt to write to any file below /etc
  condition: write_etc_common
  output: "File below /etc opened for writing (user=%user.name user_loginuid=%user.loginuid command=%proc.cmdline pid=%proc.pid parent=%proc.pname pcmdline=%proc.pcmdline file=%fd.name program=%proc.name gparent=%proc.aname[2] ggparent=%proc.aname[3] gggparent=%proc.aname[4] container_id=%container.id image=%container.image.repository)"
  priority: ERROR
  tags: [filesystem, mitre_persistence]
```

Edit the file `/etc/falco/falco_rules.local.yaml`.

```
$ sudo vim /etc/falco/falco_rules.local.yaml
```

Modify the rule from `/etc/falco/falco_rules.yaml` and add it to `/etc/falco/falco_rules.local.yaml`, as follows.

```yaml
- rule: Write below etc
  desc: an attempt to write to any file below /etc
  condition: write_etc_common
  output: "%evt.time,%user.name,%container.id"
  priority: ERROR
  tags: [filesystem, mitre_persistence]
```

Restart the Falco service, and find the changed output in the Falco logs.

```
$ sudo systemctl restart falco
$ sudo journalctl -fu falco
Apr 09 15:24:57 kube-worker-1 falco[22412]: 15:24:57.713602963: Error 15:24:57.713602963,root,e900d9ed474a...
```

Stop the running command with `CTRL + C`.

Edit the file `/etc/falco/falco.yaml` in order to change the output channel.

```
$ sudo vim /etc/falco/falco.yaml
```

Disable standard output, enable file output, and point the `file_output` attribute to the file `/var/log/falco.log`. The resulting configuration will look as shown below.

```yaml
file_output:
  enabled: true
  keep_alive: false
  filename: /var/log/falco.log

stdout_output:
  enabled: false
```

The log file will now append Falco logs.

```
$ sudo tail -f /var/log/falco.log
15:26:07.738036030: Error 15:26:07.738036030,root,e900d9ed474a
...
```

Stop the running command with `CTRL + C`.