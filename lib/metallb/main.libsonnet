local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

local ns = 'metallb';

{
  metalNs: k.core.v1.namespace.new(ns),
  metalCertIssuer: {
    apiVersion: 'cert-manager.io/v1',
    kind: 'Issuer',
    metadata: {
      name: 'webhook-server-cert-issuer',
      namespace: ns,
    },
    spec: {
      selfSigned: {},
    },
  },
  metalCert: {
    apiVersion: 'cert-manager.io/v1',
    kind: 'Certificate',
    metadata: {
      name: 'webhook-server-cert',
      namespace: ns,
    },
    spec: {
      commonName: 'metallb-webhook-service.default.svc',
      dnsNames: [
        'metallb-webhook-service.default.svc.cluster.local',
        'metallb-webhook-service.default.svc'
      ],
      issuerRef: {
        kind: 'Issuer',
        name: 'webhook-server-cert-issuer',
      },
      secretName: 'webhook-server-cert',
    },
  },
  metal: helm.template('metallb', '../../charts/metallb', {
    namespace: ns,
  }),
}
