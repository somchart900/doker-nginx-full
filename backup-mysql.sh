#!/bin/bash

# ตั้งค่าตัวแปร
CONTAINER_NAME="mysql"
DB_NAME="nginx"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="./backup-db"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql.gz"
MAX_BACKUPS=10

# สร้างโฟลเดอร์ backup ถ้ายังไม่มี
mkdir -p "$BACKUP_DIR"

# Backup database และ gzip
echo "💾 กำลัง backup database $DB_NAME ..."
docker exec -i "$CONTAINER_NAME" sh -c "mysqldump $DB_NAME" | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
  echo "✅ Backup สำเร็จ: $BACKUP_FILE"
else
  echo "❌ Backup ล้มเหลว"
  exit 1
fi

# หมุนเวียนไฟล์เก่า ถ้าเกิน MAX_BACKUPS
BACKUP_COUNT=$(ls "$BACKUP_DIR"/*.sql.gz 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
  echo "🧹 ลบไฟล์ backup เก่าเกิน $MAX_BACKUPS ..."
  ls -1t "$BACKUP_DIR"/*.sql.gz | tail -n +$((MAX_BACKUPS + 1)) | while read -r old_file; do
    rm -f "$old_file"
    echo "🔥 ลบ: $old_file"
  done
fi

echo "🎉 งาน backup เสร็จเรียบร้อย"
