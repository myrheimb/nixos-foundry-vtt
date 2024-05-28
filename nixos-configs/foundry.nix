{ pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.unzip  # Foundry needs this to install modules
    pkgs.nodejs_18
  ];

  # Open the required ports in the firewall
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # The service below expects to find the Foundry VTT files in /opt/foundry/vtt
  # and the data files in /opt/foundry/data
  systemd.services.foundryvtt = {
    description = "Foundry Virtual Tabletop";
    serviceConfig = {
      Type = "simple";
      RuntimeDirectory = "/opt/foundry/vtt";
      ExecStart = "${pkgs.nodejs_18}/bin/node /opt/foundry/vtt/resources/app/main.js --dataPath=/opt/foundry/data";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.foundryvtt.enable = true;

}
