@echo off
cd /d "%~dp0"
echo ---------------------------------------- >> auto_push.log
echo Starting auto-push at %date% %time% >> auto_push.log

git add . >> auto_push.log 2>&1
git commit -m "Daily auto-commit: %date%" >> auto_push.log 2>&1
git push >> auto_push.log 2>&1

echo Finished auto-push at %date% %time% >> auto_push.log
echo ---------------------------------------- >> auto_push.log
