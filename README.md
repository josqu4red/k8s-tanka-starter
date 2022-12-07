# Kubernetes lab with Kind and Tanka

### Prerequisites

* with Nix: run `nix develop` to get a shell with required tools
* without: install *dependencies* listed in [flake.nix](flake.nix)

### Bootstrap

```sh
find . -name chartfile.yaml -print0 | xargs -0 -I{} -n1 -P4 sh -c 'cd "$(dirname {})"; tk tool charts vendor' # Vendor required helm charts
kind create cluster --config cluster.yaml                                                                     # Create local cluster
tk apply environments/kind                                                                                    # Create resources in cluster
```

Done.
