{ pkgs, config, inputs, ... }: {
  home.shellAliases = {
    psa = "podman ps -a";
    skibidi = "git add . && sudo nixos-rebuild switch --flake .#nixos";
    gitout = "git add . && sudo nixos-rebuild switch --flake .#nixos && git commit -m 'sum new sauce'";
  };

  home.packages = [
    pkgs.atool
    pkgs.httpie
    pkgs.htop
    pkgs.wget
  ];

  programs.bash.enable = true;

  #secrets
  sops = {
    defaultSopsFile = ./secrets/git-secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/jonpinto/.config/sops/age/keys.txt";
    secrets.github_token = {
    };
  };

  programs.git = {
    enable = true;
    userName = "jonpinto";
    userEmail = "yonatanpinto1@gmail.com";
    extraConfig = {
      credential.helper = "!f() { echo \"password=$(cat ${config.sops.secrets.github_token.path})\"; }; f";
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };
  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "25.11";
}
