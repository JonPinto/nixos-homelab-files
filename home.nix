{ pkgs, ... }: {
  home.packages = [ 
    pkgs.atool 
    pkgs.httpie 
    pkgs.htop
    pkgs.wget
  ];

  programs.bash.enable = true;

  programs.git = {
    enable = true;
    userName = "jonpinto";
    userEmail = "yonatanpinto1@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };
  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "25.11";
}