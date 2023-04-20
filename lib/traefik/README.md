# traefik

# Custom resources

Install libs:
```
jb install github.com/jsonnet-libs/traefik-libsonnet@main
```

then in configs:
```
local traefik = import 'github.com/jsonnet-libs/traefik-libsonnet/2.9.8/main.libsonnet';
local ingressRoute = traefik.v1alpha1.ingressRoute;
```
