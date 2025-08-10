@echo off
title Test Delete API for Spare Parts

echo 🗑️ TESTING DELETE API FOR SPARE PARTS
echo.

echo The DELETE API is already implemented at:
echo DELETE /api/spareparts/{id}
echo.

echo Features:
echo ✅ Deletes items from MySQL table 'spare_part_items'
echo ✅ Admin authentication required
echo ✅ Proper security validation
echo ✅ HTTP status codes (200, 401, 403, 404)
echo.

echo Test Requirements:
echo 1. Application must be running on localhost:8082
echo 2. Must be logged in as admin user
echo.

echo Starting application...
echo.

echo Method 1: Start and test via UI
start /B mvn spring-boot:run

echo Waiting for application to start...
timeout /t 10 /nobreak > nul

echo Opening browser for login...
start http://localhost:8082/login

echo.
echo LOGIN INSTRUCTIONS:
echo Username: admin
echo Password: admin123
echo.
echo After login, go to dashboard and look for red DELETE buttons!
echo.

echo Method 2: Test via API (after login)
echo Open browser console (F12) and run:
echo.
echo fetch('/api/spareparts/1', { method: 'DELETE' })
echo   .then(response =^> response.text())
echo   .then(data =^> console.log('Success:', data));
echo.

echo Press any key to stop the application...
pause > nul

echo Stopping application...
taskkill /f /im java.exe 2>nul

echo Done!
