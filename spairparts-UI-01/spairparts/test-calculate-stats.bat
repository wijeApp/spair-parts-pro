@echo off
echo ========================================
echo Testing calculateInitialStats Fix (spareparts_prod)
echo ========================================

echo.
echo This script will:
echo 1. Start the Spring Boot application
echo 2. Open browser with developer console
echo 3. Check if statistics are calculated correctly
echo.

echo Starting the application...
start "" /B mvn spring-boot:run -Dspring-boot.run.profiles=dev

echo.
echo Waiting for application to start (15 seconds)...
timeout /t 15 /nobreak > nul

echo.
echo Opening browser with instructions...
echo.

echo ========================================
echo TESTING INSTRUCTIONS:
echo ========================================
echo.
echo 1. Open Developer Console (F12)
echo 2. Look for these console messages:
echo    - "=== DEBUG: Analyzing item structure ==="
echo    - "Final calculated statistics:"
echo    - Should show correct totalItems count
echo.
echo 3. Check the dashboard cards:
echo    - Total Items should show correct count
echo    - Total Value should be calculated
echo    - Low Stock Items should be counted
echo    - Average Price should be calculated
echo.
echo 4. Test search functionality:
echo    - Search for an item name
echo    - Total Items should update to filtered count
echo    - Clear search - count should restore
echo.
echo 5. If you see "No items found with primary method"
echo    - Check if alternative method worked
echo    - Look for "Alternative method found: X items"
echo.
echo ========================================

start "" "http://localhost:8080/spareparts"

echo.
echo Press any key to stop the application...
pause > nul

echo.
echo Stopping application...
taskkill /f /im java.exe /im javaw.exe 2>nul

echo.
echo Test completed.
pause
