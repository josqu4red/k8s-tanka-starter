# Kubernetes lab with Kind and Tanka

### Prerequisites

* with Nix: run `nix develop` to get a shell with required tools
* without: install *dependencies* listed in [flake.nix](flake.nix) and set `KUBECONFIG=.kubecfg`

### Bootstrap

```sh
tk tool charts vendor                                             # Vendor required helm charts
kind create cluster --config cluster.yaml --kubeconfig .kubecfg   # Create local cluster
tk apply environments/kind                                        # Create resources in cluster
```

Done.
