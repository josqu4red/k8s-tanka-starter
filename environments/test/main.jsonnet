local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
{
  testNs: k.core.v1.namespace.new('test'),
} + (import 'nginx/main.libsonnet')
