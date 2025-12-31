{pkgs, ...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Determinate Nix is installed; avoid conflicting daemon/config management.
  nix.enable = false;

  # ─────────────────────────────────────────────────────────────────────────────
  # Automatic Garbage Collection (via launchd, since Determinate Nix is used)
  # ─────────────────────────────────────────────────────────────────────────────
  launchd.daemons.nix-gc = {
    command = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 14d";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Weekday = 0; # Sunday
          Hour = 3;
          Minute = 0;
        }
      ];
      StandardOutPath = "/var/log/nix-gc.log";
      StandardErrorPath = "/var/log/nix-gc.log";
    };
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # Nix Store Optimization (hard-link identical files)
  # ─────────────────────────────────────────────────────────────────────────────
  launchd.daemons.nix-optimise = {
    command = "${pkgs.nix}/bin/nix store optimise";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Weekday = 0; # Sunday
          Hour = 4;
          Minute = 0;
        }
      ];
      StandardOutPath = "/var/log/nix-optimise.log";
      StandardErrorPath = "/var/log/nix-optimise.log";
    };
  };
}
