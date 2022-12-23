local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';

(import './config.libsonnet') +
{
  local deployment = k.apps.v1.deployment,
  local container = k.core.v1.container,
  local port = k.core.v1.containerPort,
  local service = k.core.v1.service,
  local ingress = k.networking.v1.ingress,
  local irule = k.networking.v1.ingressRule,
  local hip = k.networking.v1.httpIngressPath,

  local cfg = $._config.nginx,

  nginx: {
    deployment: deployment.new(
      name=cfg.name,
      replicas=1,
      containers=[
        container.new(cfg.name, cfg.image)
        + container.withPorts([port.new('web', cfg.port)]),
      ],
    ),
    service: k.util.serviceFor(self.deployment),
    ingress: ingress.new(cfg.name)
             + ingress.spec.withRules(
               irule.http.withPaths(
                 hip.withPath('/simple') +
                 hip.withPathType('Prefix') +
                 hip.backend.service.withName(cfg.name) +
                 hip.backend.service.port.withNumber(cfg.port)
               )
             ),
  },
}
