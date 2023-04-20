local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

local ns = 'traefik';

{
  traefikNs: k.core.v1.namespace.new(ns),
  traefik: helm.template('traefik', '../../charts/traefik', {
    namespace: ns,
    includeCrds: true,
    values: {
      ingressRoute: {
        dashboard: {
          enabled: false,
        },
      },
    },
  }),
}
