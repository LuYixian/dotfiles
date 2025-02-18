{ pkgs, ... }: {

  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  # TODO Fell free to add your favorite packages here.
  environment.systemPackages = with pkgs; [
    act
    age
    aria2
    asciinema
    bat
    bat-extras.prettybat
    bat-extras.batwatch
    bat-extras.batpipe
    bat-extras.batman
    bat-extras.batgrep
    bat-extras.batdiff
    dust
    fastfetch
    fd
    ffmpeg
    fzf
    gh
    ghq
    git
    git-lfs
    go
    hyperfine
    jq
    just # use Justfile to simplify nix-darwin's commands 
    lazygit
    lsd
    navi
    nerdfonts
    neovim
    onefetch
    openssh
    openssl
    ouch
    p7zip
    p7zip-rar
    pdm
    poppler
    pueue
    ripgrep
    ripgrep-all
    sd
    sheldon
    sniffnet
    starship
    tenv
    tlrc
    tmux
    tokei
    wget
    yarn-berry
    yazi
    yq-go
    zoxide
    zstd
    k9s
  ];
  environment.variables.EDITOR = "nvim";
}