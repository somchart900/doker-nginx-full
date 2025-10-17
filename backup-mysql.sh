#!/bin/bash

# โหลดค่าจาก .env
source .env

# ตั้งค่าตัวแปร
CONTAINER_NAME="mysql-db"
DB_NAME="${MYSQL_DATABASE}"
DB_USER="root"
DB_PASS="${MYSQL_ROOT_PASSWORD}"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="./backup"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql"

# สร้างโฟลเดอร์ backup ถ้ายังไม่มี
mkdir -p "$BACKUP_DIR"

# ลบไฟล์เก่าถ้าเกิน 10
FILE_COUNT=$(ls "$BACKUP_DIR"/*.sql 2>/dev/null | wc -l)
if [ "$FILE_COUNT" -ge 10 ]; then
  echo "🧹 มีมากกว่า 10 ไฟล์ ลบไฟล์เก่าสุด..."
  ls -1t "$BACKUP_DIR"/*.sql | tail -n +11 | while read -r old_file; do
    echo "🔥 ลบ: $old_file"
    rm -f "$old_file"
  done
fi

# รัน mysqldump ผ่าน docker exec
docker exec "$CONTAINER_NAME" \
  mysqldump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_FILE"

# ตรวจสอบผลลัพธ์
if [ $? -eq 0 ]; then
  echo "✅ Backup สำเร็จ: $BACKUP_FILE"
else
  echo "❌ Backup ล้มเหลว"
fi

