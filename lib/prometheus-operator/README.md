# prometheus-operator

# Custom resources

Install libs:
```
jb install github.com/jsonnet-libs/prometheus-operator-libsonnet@main
```

then in configs:
```
local promop = import 'github.com/jsonnet-libs/prometheus-operator-libsonnet/0.62/main.libsonnet';
local serviceMon = promop.monitoring.v1.serviceMonitor;
```
