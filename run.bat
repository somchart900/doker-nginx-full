@echo off
:s
echo d = run docker dev mode
echo p = run docker production mode
set /p name=Enter Command: 

if "%name%"=="d" goto :dev
if "%name%"=="p" goto :prod

echo Invalid option
pause
cls
goto :s
exit

:dev
docker compose -f dev.yml up -d
echo .
echo .
mutagen sync create ./project docker://nginx/var/www/html
echo .
echo .
echo Press any key to stop dev containers...
echo .
echo .
pause
docker compose -f dev.yml down
mutagen sync terminate -a
mutagen daemon stop
taskkill /F /IM mutagen.exe >nul 2>&1
exit

:prod
docker compose -f production.yml up -d
echo .
echo .
mutagen sync create ./project docker://nginx/var/www/html
echo .
echo .
echo Press any key to stop production containers...
echo .
echo .
pause
docker compose -f production.yml down
mutagen sync terminate -a
mutagen daemon stop
taskkill /F /IM mutagen.exe >nul 2>&1
exit
