#!/bin/bash
set -e

# Create config directories
mkdir -p /config/rclone /config/cloudflared

# Load configs from secrets (provided in Koyeb)
echo "$RCLONE_CONFIG" > /config/rclone/rclone.conf
echo "$TUNNEL_JSON" > /config/cloudflared/tunnel.json

# Start rclone mount in background
rclone mount gdrive:/ "$MOUNT_DIR" \
    --allow-other \
    --vfs-cache-mode full \
    --dir-cache-time 1h &

# Start cloudflared tunnel in background
cloudflared tunnel --credentials-file /config/cloudflared/tunnel.json run "$TUNNEL_NAME" &

# Start Jellyfin
exec /jellyfin/jellyfin
