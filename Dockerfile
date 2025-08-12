FROM jellyfin/jellyfin:latest

USER root

# Install dependencies: rclone, cloudflared, supervisor
RUN apt-get update && \
    apt-get install -y curl unzip fuse3 supervisor && \
    curl https://rclone.org/install.sh | bash && \
    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb && \
    dpkg -i cloudflared.deb && \
    rm -f cloudflared.deb && \
    mkdir -p /media/gdrive /config/rclone /config/cloudflared /var/log/supervisor

# Environment variables
ENV MOUNT_DIR=/media/gdrive
ENV TUNNEL_NAME=mytunnel
ENV RCLONE_CONFIG_PATH=/config/rclone/rclone.conf
ENV TUNNEL_JSON_PATH=/config/cloudflared/tunnel.json

# Copy configs
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

ENTRYPOINT ["/startup.sh"]
