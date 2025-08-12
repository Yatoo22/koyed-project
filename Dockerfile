FROM jellyfin/jellyfin:latest

USER root

# Install dependencies: rclone, cloudflared
RUN apt-get update && \
    apt-get install -y curl unzip fuse3 && \
    curl https://rclone.org/install.sh | bash && \
    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb && \
    dpkg -i cloudflared.deb && \
    rm -f cloudflared.deb && \
    mkdir -p /media/gdrive /config/rclone /config/cloudflared

# Environment variables
ENV MOUNT_DIR=/media/gdrive
ENV TUNNEL_NAME=mytunnel

# Copy startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
