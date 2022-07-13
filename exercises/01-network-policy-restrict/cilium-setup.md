# Setting up Cilium

## Using Minikube

If you are using minikube, you will need to use the following command line options when starting the cluster. This will prepare the cluster for the installation of Cilium. Refer to the [Cilium documentation](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/) for more information.

```
$ minikube start --network-plugin=cni --cni=false
```

The following commands to download Cilium for use with Minikube on MacOSX.

```
$ curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-darwin-amd64.tar.gz{,.sha256sum}
$ shasum -a 256 -c cilium-darwin-amd64.tar.gz.sha256sum
$ sudo tar xzvfC cilium-darwin-amd64.tar.gz /usr/local/bin
$ rm cilium-darwin-amd64.tar.gz{,.sha256sum}
```

Install Cilium with the following command.

```
$ cilium install
🔮 Auto-detected Kubernetes kind: minikube
✨ Running "minikube" validation checks
✅ Detected minikube version "1.24.0"
ℹ️  using Cilium version "v1.10.11"
🔮 Auto-detected cluster name: minikube
🔮 Auto-detected IPAM mode: cluster-pool
🔮 Auto-detected datapath mode: tunnel
🔑 Created CA in secret cilium-ca
🔑 Generating certificates for Hubble...
🚀 Creating Service accounts...
🚀 Creating Cluster roles...
🚀 Creating ConfigMap for Cilium version 1.10.11...
🚀 Creating Agent DaemonSet...
🚀 Creating Operator Deployment...
⌛ Waiting for Cilium to be installed and ready...
♻️  Restarting unmanaged pods...
♻️  Restarted unmanaged pod default/other
♻️  Restarted unmanaged pod g04/backend
♻️  Restarted unmanaged pod g04/frontend
✅ Cilium was successfully installed! Run 'cilium status' to view installation health
```

## Using a Regular Kubernetes Cluster

You can install Cilium on any generic Kubernetes cluster. The following instructions use Helm. Refer to the [Cilium documentation](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/) for more information.

First, install Cilium 1.11.6. This assumes that you have Helm installed already.

```
$ helm repo add cilium https://helm.cilium.io/
$ helm install cilium cilium/cilium --version 1.11.6 --namespace kube-system
```
Cilium provides a CLI tool for interating with the Cilium installation. The following commands install the CLI tool and ensure that the Cilium installation is ready to be used.

```
$ curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
$ sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
$ sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
$ rm cilium-linux-amd64.tar.gz{,.sha256sum}
$ cilium status --wait
```