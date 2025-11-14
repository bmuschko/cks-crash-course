# Installing the Kubernetes BOM Tool

The Kubernetes BOM (Bill of Materials) tool is used to generate, inspect, and validate Software Bill of Materials (SBOM) documents for container images and Kubernetes releases. This guide covers installation methods for different platforms.

Download pre-built binaries from the [GitHub releases page](https://github.com/kubernetes-sigs/bom/releases/).

## Linux (amd64)

```bash
$ curl -L https://github.com/kubernetes-sigs/bom/releases/download/v0.7.1/bom-amd64-linux -o bom
$ sudo mv ./bom /usr/local/bin/bom
$ sudo chmod +x /usr/local/bin/bom
```

## Linux (arm64)

```bash
$ curl -L https://github.com/kubernetes-sigs/bom/releases/download/v0.7.1/bom-arm64-linux -o bom
$ sudo mv ./bom /usr/local/bin/bom
$ sudo chmod +x /usr/local/bin/bom
```

## macOS (amd64)

```bash
$ curl -L https://github.com/kubernetes-sigs/bom/releases/download/v0.7.1/bom-amd64-darwin -o bom
$ sudo mv ./bom /usr/local/bin/bom
$ sudo chmod +x /usr/local/bin/bom
```

## macOS (arm64 / Apple Silicon)

```bash
$ curl -L https://github.com/kubernetes-sigs/bom/releases/download/v0.7.1/bom-arm64-darwin -o bom
$ sudo mv ./bom /usr/local/bin/bom
$ sudo chmod +x /usr/local/bin/bom
```

## Windows

Download the Windows executable:

```powershell
Invoke-WebRequest -Uri https://github.com/kubernetes-sigs/bom/releases/download/v0.7.1/bom-amd64-windows.exe -OutFile bom.exe
```

Move the executable to a directory in your PATH.