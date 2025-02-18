{ ... }:
{
  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    # `brew install`
    # TODO Feel free to add your favorite packages here.
    brews = [
      "macos-trash"
    ];

    # `brew install --cask`
    # TODO Feel free to add the apps you need here.
    casks = [
      "visual-studio-code"
      "iina" # video player
      "raycast" # (HotKey: alt/option + space)search, caculate and run scripts(with many plugins)
      "eudic"
      "1password-cli"
      "alt-tab"
      "cheatsheet"
      "keyboardcleantool"
      "ghostty"
      "mockoon"
      "nikitabobko/tap/aerospace"
      "ngrok"
      "orbstack"
      "slack"
    ];
  };

    taps = [
      "homebrew/services"
      "homebrew/bundle"
    ];
}
