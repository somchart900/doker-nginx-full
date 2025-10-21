@echo off
wsl -d Ubuntu -- bash -ic "cd ~/nginx && ./down.sh"
pause