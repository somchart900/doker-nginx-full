@echo off
wsl -d Ubuntu -- bash -ic "cd ~/nginx && ./up.sh"
pause