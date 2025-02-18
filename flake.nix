{
  description = "YixianLu's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:

  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.act
          pkgs.age
          pkgs.asciinema
          pkgs.bat
          pkgs.bat-extras.prettybat
          pkgs.bat-extras.batwatch
          pkgs.bat-extras.batpipe
          pkgs.bat-extras.batman
          pkgs.bat-extras.batgrep
          pkgs.bat-extras.batdiff
          pkgs.dust
          pkgs.fastfetch
          pkgs.fd
          pkgs.ffmpeg
          pkgs.fzf
          pkgs.gh
          pkgs.ghq
          pkgs.git
          pkgs.git-lfs
          pkgs.go
          pkgs.hyperfine
          pkgs.jq
          pkgs.lazygit
          pkgs.lsd
          pkgs.navi
          pkgs.nerdfonts
          pkgs.neovim
          pkgs.onefetch
          pkgs.openssh
          pkgs.openssl
          pkgs.ouch
          pkgs.p7zip
          pkgs.p7zip-rar
          pkgs.pdm
          pkgs.poppler
          pkgs.pueue
          pkgs.ripgrep
          pkgs.ripgrep-all
          pkgs.sd
          pkgs.sheldon
          pkgs.sniffnet
          pkgs.starship
          pkgs.tenv
          pkgs.tlrc
          pkgs.tmux
          pkgs.tokei
          pkgs.wget
          pkgs.yarn-berry
          pkgs.yazi
          pkgs.yq-go
          pkgs.zoxide
          pkgs.zstd
          pkgs.k9s
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
