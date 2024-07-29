# NixOS PIA Service Module
The contained module, pia.nix, defines a systemd service that manages a PIA VPN connection. It is built on a fork of the pia-foss manual-connections repository and resuses the scripts provided, simply wrapping them in a service.

# Usage
To use the module, import into configuration.nix and configure like so
{
  imports = 
    [
      /path/to/repo/pia.nix
    ];
  
  services.pia = {
    enable = true;
    piauser = "";
    piapass = "";
  };
}