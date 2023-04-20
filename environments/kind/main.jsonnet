(import 'cert-manager/main.libsonnet')
+ (import 'traefik/main.libsonnet')
+ {
  _config+:: {
    traefik+: {
      service: {
        type: 'NodePort',
      },
      ports: {
        web: { nodePort: 32080 },
        websecure: { nodePort: 32443 },
      },
    },
  },
}
