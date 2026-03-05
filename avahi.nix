{ config, pkgs, ... }:

{
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Allows software to find .local addresses
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      userServices = true;
    };
  };
}
