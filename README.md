# NixOS Foundry VTT
Host Foundry VTT on your NixOS server using NodeJS and Caddy.
Caddy will take care of setting up and updating an SSL certificate automatically.

## Prerequisites
- [NixOS](https://nixos.org) server.
- [Foundry VTT](https://foundryvtt.com) license.
- Domain name with DNS configured.

## Setup
1. Log in to your account on https://foundryvtt.com, go to **Purchased Licenses**, select **Linux/NodeJS** as your Operating system, and click on **Download**.

1. Copy the `.zip` file over to your server using e.g. [scp](https://man.openbsd.org/scp.1) or [rsync](https://download.samba.org/pub/rsync/rsync.1) and run the following (edit the version number).
    ```bash
    mkdir -p /opt/foundry/vtt /opt/foundry/data/Config /opt/livekit
    unzip FoundryVTT-xx.xxx.zip -d /opt/foundry/vtt
    ```

1. Copy the contents of [options.json](foundry/data/Config/options.json) to your server and replace the two mentions of `domain.tld` with your own domain name.
    ```bash
    nano /opt/foundry/data/Config/options.json
    ```

1. Copy the contents of [config.yaml](livekit/config.yaml) to your server and replace the API key and secret with your own.
    ```bash
    nix-shell -p livekit --command "livekit-server generate-keys" > /opt/livekit/config.yaml
    nano /opt/livekit/config.yaml
    ```

1. Copy the contents of [caddy.nix](nixos-configs/caddy.nix) to your server and replace `domain.tld` with your own domain name.
    ```bash
    nano /etc/nixos/caddy.nix
    ```

1. Copy the contents of [foundry.nix](nixos-configs/foundry.nix) to your server.
    ```bash
    nano /etc/nixos/foundry.nix
    ```

1. Add the two new `.nix` files to your `configuration.nix` file's import section.
    ```bash
    nano /etc/nixos/configuration.nix
    ```
    ```nix
    imports = [
        ./caddy.nix
        ./foundry.nix
    ];
    ```

1. Rebuild NixOS to enable the new  `caddy`, `foundryvtt`, and `livekit` services and your new Foundry VTT server should now be online and accessible!
    ```bash
    nixos-rebuild switch
    ```

1. Lastly, when configuring your Foundry server, be sure to install the [LiveKit AVClient module](https://github.com/bekriebel/fvtt-module-avclient-livekit?tab=readme-ov-file#installation) and enable it to use LiveKit instead of the built-in A/V client.
The **LiveKit Server Address** will be `your-domain.tld/livekit`.
