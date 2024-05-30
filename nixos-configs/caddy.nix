{ services, ... }:
{
  services.caddy.enable = true;

  services.caddy = {
    virtualHosts."domain.tld".extraConfig = ''
      encode zstd gzip

      header {
        # disable FLoC tracking
        Permissions-Policy interest-cohort=()
        # Enable HTTP Strict Transport Security (HSTS)
        Strict-Transport-Security "max-age=16000000; includeSubDomains; preload;"
        # Enable cross-site filter (XSS) and tell browser to block detected attacks
        X-XSS-Protection "1; mode=block"
        # Disallow the site to be rendered within a frame (clickjacking protection)
        X-Frame-Options "SAMEORIGIN"
        # Avoid MIME type sniffing
        X-Content-Type-Options "nosniff"
        # Mitigate the risk of leaking data cross-origins
        Referrer-Policy "strict-origin-when-cross-origin"
        # Prevent search engines from indexing (optional)
        X-Robots-Tag "none"
        # Remove the server name
        -Server
      }

      # Send it to the backend
      route /* {
        reverse_proxy http://localhost:30000 {
          transport http {
            keepalive 10s
          }
          # Set ip for logs
          header_up X-Real-IP {remote_host}
        }
      }

      route /livekit* {
        uri strip_prefix /livekit
        reverse_proxy http://localhost:7880 {
          transport http {
            keepalive 10s
          }
        }
      }
    '';
  };
}
