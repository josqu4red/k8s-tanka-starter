{
  description = "Kubernetes lab";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = inputs:
  let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs { inherit system; };
    cluster-name = "k8s-tanka-starter";

    k8s-tanka-init = pkgs.writeShellScriptBin "k8s-tanka-init" ''
      ${pkgs.tanka}/bin/tk tool charts vendor
      ${pkgs.kind}/bin/kind create cluster --name ${cluster-name} --config cluster.yaml --kubeconfig .kubecfg
      ${pkgs.tanka}/bin/tk apply environments/kind --auto-approve always
    '';

    k8s-tanka-cleanup = pkgs.writeShellScriptBin "k8s-tanka-cleanup" ''
      ${pkgs.kind}/bin/kind delete cluster --name ${cluster-name}
    '';

    dependencies = with pkgs; [
      k8s-tanka-init
      k8s-tanka-cleanup
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
