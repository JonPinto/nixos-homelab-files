# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./avahi.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nix-ld.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # Set the static IP for your specific card
    interfaces.enp2s0f0.ipv4.addresses = [{
      address = "10.0.0.99";
      prefixLength = 24;
    }];
    # your router's IP
    defaultGateway = "10.0.0.138";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  # networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.firewall.allowPing = true;

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IL";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "he_IL.UTF-8";
    LC_IDENTIFICATION = "he_IL.UTF-8";
    LC_MEASUREMENT = "he_IL.UTF-8";
    LC_MONETARY = "he_IL.UTF-8";
    LC_NAME = "he_IL.UTF-8";
    LC_NUMERIC = "he_IL.UTF-8";
    LC_PAPER = "he_IL.UTF-8";
    LC_TELEPHONE = "he_IL.UTF-8";
    LC_TIME = "he_IL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "il";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "il";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonpinto.isNormalUser = true;
  # Points to Home-Manager
  home-manager.users.jonpinto = import ./home.nix;
  users.users.jonpinto = {
    description = "Jonathan";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    packages = with pkgs; [];
    linger = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnXgi3W08JcgD0qU/hl4p4cR0ZfdLl0T2DghoHUIZVb yonat@DESKTOP-QQO1ES2"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    podman-compose
  # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  #podman
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  virtualisation.oci-containers.containers."dockge" = {
    image = "louislam/dockge:1";
    autoStart = true;
    ports = [ "5001:5001" ];
    volumes = [
      "/run/podman/podman.sock:/var/run/docker.sock"
      "/opt/dockge:/app/data"
      "/opt/stacks:/opt/stacks"
    ];
    environment = {
      DOCKGE_STACKS_DIR = "/opt/stacks";
    };
  };

  fileSystems."/var/lib/stacks/glance" = {
    device = "/home/jonpinto/nix-config/.dotfiles/glance";
    options = [ "bind" ];
  };

  systemd.sockets.podman.wantedBy = [ "sockets.target" ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 53 80 81 443 3923 3010 ];
      allowedUDPPorts = [ 53 5353 ];
      interfaces."podman*".allowedUDPPorts = [ 53 5353 ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
