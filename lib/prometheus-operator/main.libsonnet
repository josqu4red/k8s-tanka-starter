local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

local ns = 'prometheus';

{
  promNs: k.core.v1.namespace.new(ns),
  prom: helm.template('prometheus-operator', '../../charts/kube-prometheus-stack', {
    namespace: ns,
    includeCrds: true,
    values: {
      alertmanager: {
        enabled: false,
      },
      grafana: {
        enabled: false,
      },
    },
  }),
}
