local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local certmgr = import 'github.com/jsonnet-libs/cert-manager-libsonnet/1.10/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

local ns = 'metallb';

{
  local cert = certmgr.nogroup.v1.certificate,
  local issuer = certmgr.nogroup.v1.issuer,

  metalNs: k.core.v1.namespace.new(ns),
  metalCertIssuer: issuer.new('webhook-server-cert-issuer')
                   + issuer.metadata.withNamespace(ns)
                   + { spec: { selfSigned: {} } },

  metalCert: cert.new('webhook-server-cert')
             + cert.metadata.withNamespace(ns)
             + cert.spec.withCommonName('metallb-webhook-service.' + ns + '.svc')
             + cert.spec.withSecretName('webhook-server-cert')
             + cert.spec.withDnsNames([
               'metallb-webhook-service.' + ns + '.svc.cluster.local',
               'metallb-webhook-service.' + ns + '.svc',
             ])
             + cert.spec.issuerRef.withKind('Issuer')
             + cert.spec.issuerRef.withName('webhook-server-cert-issuer'),

  metal: helm.template('metallb', '../../charts/metallb', {
    namespace: ns,
  }) + {
    service_metallb_webhook_service+: {
      metadata+: {
        namespace: ns,
      },
    },
  },
}
