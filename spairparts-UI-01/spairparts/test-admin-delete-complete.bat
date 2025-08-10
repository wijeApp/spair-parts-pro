@echo off
echo.
echo =====================================================
echo   ADMIN DELETE FUNCTIONALITY - QUICK TEST
echo =====================================================
echo.

echo Checking if application is running on port 8082...
powershell -Command "Get-NetTCPConnection -LocalPort 8082 -ErrorAction SilentlyContinue | Select-Object LocalPort, State"

if errorlevel 1 (
    echo.
    echo ❌ Application is not running on port 8082
    echo Please start the application first:
    echo    mvn spring-boot:run
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Application is running!
echo.
echo 🧪 TESTING INSTRUCTIONS:
echo.
echo 1. LOGIN AS ADMIN:
echo    URL: http://localhost:8082/login
echo    Username: Admin
echo    Password: Admin123
echo.
echo 2. VERIFY ADMIN ACCESS:
echo    - Check for "ADMIN" badge in welcome message
echo    - Look for 🗑️ Delete buttons on item cards
echo    - Open browser console (F12) and check for: isAdmin: true
echo.
echo 3. TEST DELETE FUNCTIONALITY:
echo    - Click any 🗑️ Delete button
echo    - Confirm deletion in dialog
echo    - Item should be removed from the list
echo.
echo 4. DEBUG INFO:
echo    URL: http://localhost:8082/debug/users
echo.

echo Opening login page...
start http://localhost:8082/login

echo.
echo Opening debug page...
start http://localhost:8082/debug/users

echo.
echo =====================================================
echo   TEST COMPLETE - Check browser windows
echo =====================================================
echo.
pause
