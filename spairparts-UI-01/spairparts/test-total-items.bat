@echo off
echo Testing Total Items JavaScript Fix
echo ==================================

echo.
echo Starting the application for testing...
echo.

REM Start the Spring Boot application in the background
start "" /B mvn spring-boot:run -Dspring-boot.run.profiles=dev

echo Waiting for application to start...
timeout /t 15 /nobreak > nul

echo.
echo Opening browser to test the total items functionality...
echo.
echo Test Instructions:
echo 1. Check if Total Items count shows correctly
echo 2. Try searching for items - count should update
echo 3. Clear search - count should restore
echo 4. Add new items (if admin) - count should update
echo.

start "" "http://localhost:8080/spareparts"

echo.
echo Press any key to stop the test...
pause > nul

echo Stopping application...
taskkill /f /im java.exe 2>nul

echo Test completed.
pause
