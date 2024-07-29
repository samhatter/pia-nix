{ config, lib, pkgs, ... }:

with lib;

let
  UID = 243;
  GID = 243;
  cfg = config.services.pia;
in
{
  options.services.pia = {
    enable = mkEnableOption (lib.mdDoc "Enable PIA VPN Client Service");
  
    piauser = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        PIA username
      '';
    };

    piapass = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        PIA password
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pia = {
      enable = true;
      path = with pkgs; [
        curl
        jq
        bash
        gawk
        openvpn
        procps
        iproute2
      ];
      wantedBy = [ "multi-user.target" ];
      description = "VPN Client Service";
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";

        ExecStart = "${pkgs.bash}/bin/bash  ./run_setup.sh";
        
        WorkingDirectory = "${config.system.build.filesPath}"; 
      };
   
      environment = {
        VPN_PROTOCOL="openvpn";
        DISABLE_IPV6="yes";
        AUTOCONNECT="true";
        PIA_PF="true";
        PIA_DNS="false";
        PIA_USER=cfg.piauser;
        PIA_PASS=cfg.piapass;
      };
    };
  };
}