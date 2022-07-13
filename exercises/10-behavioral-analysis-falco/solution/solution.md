# Solution

Shell into a worker node.

Create the nginx Pod with the following command:

```
$ kubectl run nginx --image=nginx:1.20.2
pod/nginx created
```

Wait until the Pod transitions into the "Running" status.

```
$ kubectl get pod nginx
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          17s
```

Create the Falco rules file named `falco-open-shell.yaml`. The contents could look as follows:

```
$ cat falco-open-shell.yaml
- rule: shell_in_container
  desc: notice shell activity within a container
  condition: container.id != host and proc.name = bash
  output: shell in a container (user=%user.name container_name=%container.name)
  priority: warning
```

Execute Falco with the following command.

```
$ sudo falco -r falco-open-shell.yaml -M 120
Fri May 13 14:02:59 2022: Falco version 0.31.1 (driver version b7eb0dd65226a8dc254d228c8d950d07bf3521d2)
Fri May 13 14:02:59 2022: Falco initialized with configuration file /etc/falco/falco.yaml
Fri May 13 14:02:59 2022: Loading rules from file rules.yaml:
Rules match ignored syscall: warning (ignored-evttype):
         loaded rules match the following events: access,brk,close,cpu_hotplug,drop,epoll_wait,eventfd,fcntl,fstat,fstat64,futex,getcwd,getdents,getdents64,getegid,geteuid,getgid,getpeername,getresgid,getresuid,getrlimit,getsockname,getsockopt,getuid,infra,k8s,llseek,lseek,lstat,lstat64,mesos,mmap,mmap2,mprotect,munmap,nanosleep,notification,page_fault,poll,ppoll,pread,preadv,procinfo,pwrite,pwritev,read,readv,recv,recvmmsg,select,semctl,semget,semop,send,sendfile,sendmmsg,setrlimit,shutdown,signaldeliver,splice,stat,stat64,switch,sysdigevent,timerfd_create,write,writev;
         but these events are not returned unless running falco with -A
Fri May 13 14:02:59 2022: Starting internal webserver, listening on port 8765
```

Open another shell to the worker node and exec into the container of the `nginx` Pod using the `bash` command.

```
$ kubectl exec -it nginx -- bash
root@nginx:/#
```

The shell running the `falco` executable should render a warning message similar to the one below.

```
14:03:36.445564004: Warning shell in a container (user=root container_name=k8s_nginx_nginx_default_38090d73-0fb8-4de1-b46c-42705576a05d_0)
```
