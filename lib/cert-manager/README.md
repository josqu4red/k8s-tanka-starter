# cert-manager

# Custom resources

Install libs:
```
jb install github.com/jsonnet-libs/cert-manager-libsonnet@main
```

then in configs:
```
local certmgr = import 'github.com/jsonnet-libs/cert-manager-libsonnet/1.10/main.libsonnet';
local cert = certmgr.nogroup.v1.certificate;
local issuer = certmgr.nogroup.v1.issuer;
```
