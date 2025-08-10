@echo off
echo =============================================
echo Admin Update Functionality Test
echo =============================================
echo.
echo This will test the admin update functionality...
echo.
powershell.exe -ExecutionPolicy Bypass -File "%~dp0test-admin-update.ps1"
pause
