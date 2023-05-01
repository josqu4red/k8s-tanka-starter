# Kubernetes lab with Kind and Tanka

### Prerequisites

* with Nix: run `nix develop` to get a shell with required tools (or just `direnv allow`)
* without: install *dependencies* listed in [flake.nix](flake.nix) and set `KUBECONFIG=.kubecfg`

### Bootstrap

```sh
jb install                                                        # Install jsonnet deps
tk tool charts vendor                                             # Vendor required helm charts
kind create cluster --config cluster.yaml --kubeconfig .kubecfg   # Create local cluster
tk apply environments/kind                                        # Create resources in cluster
```

A kind cluster with some core utilities should now be up and running!

### Helm charts

Tanka can deal with Helm charts and apply them all the jsonnet goodness. This repo already uses some.
Let's add cert-manager to the setup:

```sh
tk tool charts add-repo jetstack https://charts.jetstack.io
tk tool charts add jetstack/cert-manager@1.10.1             # version is mandatory, we want reproducibility
tk tool charts vendor                                       # to fetch defined charts on a fresh repo
```

Add a `lib/cert-manager/main.libsonnet` file to wrap the chart, set some values, and create a dedicated namespace:
```jsonnet
local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

local ns = 'cert-manager';

{
  certmanagerNs: k.core.v1.namespace.new(ns),
  certmanager: helm.template('cert-manager', '../../charts/cert-manager', {
    namespace: ns,
    values: {
      prometheus: { enabled: false },
      installCRDs: true,
    },
  }),
}
```

And use it in an environment (see `environments/kind/main.jsonnet`):

```jsonnet
(import 'cert-manager/main.libsonnet')
```

Run `tk apply environments/kind` to deploy.
