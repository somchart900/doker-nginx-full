@echo off
docker compose -f rclone-sync-backup.yml run --rm rclone
pasue