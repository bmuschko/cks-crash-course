# Solution

## Verifying the Installation

Verify the installation. You should see a banner rendered indicating the BOM tool version.

```bash
$ bom version
```

## Generating SBOM for kube-apiserver Image

Generate an SBOM for the kube-apiserver container image:

```bash
$ bom generate --image registry.k8s.io/kube-apiserver:v1.21.0 -o kube-apiserver-sbom.spdx
```

The output will be saved to `kube-apiserver-sbom.spdx` in SPDX format.

## Inspecting the SBOM Document

View the outline structure of the generated SBOM:

```bash
$ bom document outline kube-apiserver-sbom.spdx
```

This will display the hierarchical structure of packages and their relationships.

## Querying the SBOM for Package Name

The main package name can be found at the top of the outline structure. View the outline and look for the root package:

```bash
$ bom document outline kube-apiserver-sbom.spdx | head -20
```

The first package listed is typically the main package (in this case, it will show the kube-apiserver image).

You can also search for specific packages using the query command with filters:

```bash
$ bom document query kube-apiserver-sbom.spdx "name:kube-apiserver"
```

## Counting Total Packages

You can count lines that contain package definitions:

```bash
$ bom document outline kube-apiserver-sbom.spdx | grep -c "CONTAINS PACKAGE"
```

Or view the full outline and count packages manually:

```bash
$ bom document outline kube-apiserver-sbom.spdx
```

## Generating SBOM for Pause Image

Generate an SBOM for the pause container image in JSON format:

```bash
$ bom generate --image registry.k8s.io/pause:3.9 --format json -o pause-sbom.spdx.json
```