local k = import "github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet";
local tanka = import "github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet";
local helm = tanka.helm.new(std.thisFile);

local ns = "cert-manager";

{
  certmanagerNs: k.core.v1.namespace.new(ns),
  certmanager: helm.template("cert-manager", "../../charts/cert-manager", {
    namespace: ns,
    values: {
      prometheus: { enabled: false },
      installCRDs: true
    }
  })
}
