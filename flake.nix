{
  description = "Kubernetes lab";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = inputs:
  let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs { inherit system; };

    k8s-tanka-init = pkgs.writeShellScriptBin "k8s-tanka-init" ''
      ${pkgs.tanka}/bin/tk tool charts vendor
      ${pkgs.kind}/bin/kind create cluster --config cluster.yaml --kubeconfig .kubecfg
    '';

    dependencies = with pkgs; [
      k8s-tanka-init
      jsonnet-bundler
      kind
      kubectl
      kubernetes-helm-wrapped
      tanka
    ];
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      packages = dependencies;
      KUBECONFIG = ".kubecfg";
    };
  };
}
