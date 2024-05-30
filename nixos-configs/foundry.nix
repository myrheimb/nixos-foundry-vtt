{ pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.livekit-cli  # For interacting with LiveKit
    pkgs.unzip  # Foundry needs this to install modules
  ];

  # Open the required ports in the firewall
  # TCP 7880 and UDP 50000-60000 are for hosting LiveKit
  networking.firewall.allowedTCPPorts = [ 80 443 7880 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 50000; to = 60000; } ];

  # The foundryvtt service expects to find the Foundry VTT files in /opt/foundry/vtt
  # and the data files in /opt/foundry/data
  systemd.services.foundryvtt = {
    description = "Foundry Virtual Tabletop";
    serviceConfig = {
      Type = "simple";
      RuntimeDirectory = "/opt/foundry/vtt";
      ExecStart = "${pkgs.nodejs_20}/bin/node /opt/foundry/vtt/resources/app/main.js --dataPath=/opt/foundry/data";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.foundryvtt.enable = true;

  # The livekit service expects to find the config.yaml file in /opt/livekit
  systemd.services.livekit = {
    description = "LiveKit server for handling A/V in Foundry";
    serviceConfig = {
      Type = "simple";
      RuntimeDirectory = "/opt/livekit";
      ExecStart = "${pkgs.livekit}/bin/livekit-server --config /opt/livekit/config.yaml";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.livekit.enable = true;

}
