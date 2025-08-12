#!/bin/bash
set -e

# Create config dirs
mkdir -p /config/rclone /config/cloudflared

# Load configs from secrets
echo "$RCLONE_CONFIG" > "$RCLONE_CONFIG_PATH"
echo "$TUNNEL_JSON" > "$TUNNEL_JSON_PATH"

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
