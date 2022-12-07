{
  description = "Kubernetes lab";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = inputs:
  let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    dependencies = with pkgs; [
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
    };
  };
}
