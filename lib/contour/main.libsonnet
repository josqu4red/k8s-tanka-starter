local k = import "github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet";
local tanka = import "github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet";
local helm = tanka.helm.new(std.thisFile);

local ns = "contour";

{
  contourNs: k.core.v1.namespace.new(ns),
  contour: helm.template("contour", "../../charts/contour", {
    namespace: ns
  })
}
