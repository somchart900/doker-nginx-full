@echo off
setlocal enabledelayedexpansion

REM โหลดค่าจาก .env
for /f "tokens=1,2 delims==" %%a in (.env) do (
    set %%a=%%b
)

REM ตั้งค่าตัวแปร
set CONTAINER_NAME=mysql-db
set DB_NAME=%MYSQL_DATABASE%
set DB_USER=root
set DB_PASS=%MYSQL_ROOT_PASSWORD%
set BACKUP_DIR=backup
set TIMESTAMP=%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
set BACKUP_FILE=%BACKUP_DIR%\%DB_NAME%_%TIMESTAMP%.sql

REM สร้างโฟลเดอร์ backup ถ้ายังไม่มี
if not exist %BACKUP_DIR% (
    mkdir %BACKUP_DIR%
)

REM ลบไฟล์เก่าถ้าเกิน 10
set COUNT=0
for /f %%F in ('dir /b /a-d /o-d "%BACKUP_DIR%\*.sql"') do (
    set /a COUNT+=1
    if !COUNT! GTR 10 (
        echo 🔥 ลบไฟล์เก่า: %%F
        del "%BACKUP_DIR%\%%F"
    )
)

REM รัน mysqldump
docker exec %CONTAINER_NAME% mysqldump -u%DB_USER% -p%DB_PASS% %DB_NAME% > "%BACKUP_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo ✅ Backup สำเร็จ: %BACKUP_FILE%
) else (
    echo ❌ Backup ล้มเหลว
)
