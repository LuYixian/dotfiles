{...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Determinate Nix is installed; avoid conflicting daemon/config management.
  nix.enable = false;
}
