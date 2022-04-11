# Solution

Create and navigate to the target directory.

```
$ mkdir kubernetes-bin
$ cd kubernetes-bin
```

Copy the setup script to the directory and execute it. The download process may take a minute or two depending on your bandwidth.

```
$ cp ../setup.sh kubernetes-bin
$ ./setup.sh
```

You will find the following files in the directory.

```
$ ls
kubeadm kubectl kubelet
```

Download the checksum files for binaries with version 1.23.5.

```
$ curl -LO "https://dl.k8s.io/v1.23.5/bin/linux/amd64/kubectl.sha256"
$ curl -LO "https://dl.k8s.io/v1.23.5/bin/linux/amd64/kubeadm.sha256"
$ curl -LO "https://dl.k8s.io/v1.23.5/bin/linux/amd64/kubelet.sha256"
```

Verify the checksums against the binaries. The following commands have been run on MacOSX.

```
$ echo "$(cat kubectl.sha256)  kubectl" | shasum -a 256 --check
kubectl: OK
$ echo "$(cat kubeadm.sha256)  kubeadm" | shasum -a 256 --check
kubeadm: FAILED
shasum: WARNING: 1 computed checksum did NOT match
$ echo "$(cat kubelet.sha256)  kubelet" | shasum -a 256 --check
kubelet: OK
```

The only binary file that cannot be validated properly is `kubeadm`. It doesn't match with the version of the downloaded checksum file.