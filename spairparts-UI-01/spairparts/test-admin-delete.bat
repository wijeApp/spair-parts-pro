@echo off
REM Test Admin Delete Functionality

echo ========================================
echo Testing Admin Delete Functionality
echo ========================================

echo.
echo Starting Spring Boot application...
echo This will start the app on http://localhost:8082
echo.

echo Default test accounts:
echo - Admin: username=admin, password=admin123
echo - User:  username=user,  password=user123
echo.

start /b mvn spring-boot:run

echo.
echo Waiting for application to start...
timeout /t 15 /nobreak > nul

echo.
echo ========================================
echo TEST INSTRUCTIONS:
echo ========================================
echo.
echo 1. Open browser: http://localhost:8082/login
echo 2. Login as ADMIN (admin/admin123)
echo 3. Check dashboard for DELETE buttons on items
echo 4. Try deleting an item
echo 5. Login as USER (user/user123) 
echo 6. Verify NO delete buttons appear
echo.
echo Expected Results:
echo - Admin users: See delete buttons and can delete items
echo - Regular users: No delete buttons visible
echo.

echo Opening browser in 5 seconds...
timeout /t 5 /nobreak > nul

start http://localhost:8082/login

echo.
echo Press any key to stop the application...
pause > nul

echo Stopping application...
taskkill /f /im java.exe 2>nul
echo Done.
