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

# Copy Rclone config and Cloudflare tunnel credentials
COPY config/rclone.conf /config/rclone/rclone.conf
COPY config/tunnel.json /config/cloudflared/tunnel.json

# Environment variables
ENV RCLONE_CONFIG=/config/rclone/rclone.conf
ENV TUNNEL_NAME=mytunnel
ENV MOUNT_DIR=/media/gdrive

# Startup script
CMD rclone mount gdrive:/ "$MOUNT_DIR" --allow-other --vfs-cache-mode full --dir-cache-time 1h & \
    cloudflared tunnel --credentials-file /config/cloudflared/tunnel.json run "$TUNNEL_NAME" & \
    /jellyfin/jellyfin
