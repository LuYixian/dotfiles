
{ pkgs, lib, ... }:

{
  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.enable = false;

  nix.package = pkgs.nix;

  nix.settings = {
    # Necessary for using flakes on this system.
    experimental-features = "nix-command flakes";
    max-jobs = 8;
    # Disable auto-optimise-store because of this issue:
    #   https://github.com/NixOS/nix/issues/7273
    # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
    auto-optimise-store = false;
  };
}