@echo off
echo ========================================
echo    TESTING DELETE BUTTON FUNCTIONALITY
echo ========================================
echo.

echo [1/4] Stopping any running Java processes...
taskkill /f /im java.exe >nul 2>&1

echo [2/4] Cleaning and compiling the project...
call mvn clean compile -q

echo [3/4] Starting the Spring Boot application...
echo.
echo ⭐ IMPORTANT: Login with these credentials to test:
echo    Admin: admin / admin123 (should see delete buttons)
echo    User:  user / user123   (should NOT see delete buttons)
echo.
echo 🌐 Application will be available at:
echo    http://localhost:8082/
echo    http://localhost:8082/dashboard
echo    http://localhost:8082/spareparts-sample
echo.
echo 🔍 Check browser console (F12) for debug output:
echo    - User Info: {username, role, isAdmin}
echo    - Admin status check
echo    - Rendering item debug logs
echo.
echo [4/4] Launching application...
echo.

start "" "http://localhost:8082/login"
call mvn spring-boot:run
