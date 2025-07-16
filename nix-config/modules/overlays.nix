{ pkgs, ... }: {
  nixpkgs.overlays = [
    (self: super: {
      azure-cli = super.azure-cli.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or []) ++ [ (super.python3.withPackages (ps: [ ps.pip ])) ];
      });
    })
  ];
} 