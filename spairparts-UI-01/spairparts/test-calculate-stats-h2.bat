@echo off
echo ========================================
echo Testing calculateInitialStats Fix (H2)
echo ========================================

echo.
echo This script will:
echo 1. Start the Spring Boot application with H2 database
echo 2. Open browser with developer console
echo 3. Check if statistics are calculated correctly
echo.

echo Starting the application with H2 database profile...
start "" /B mvn spring-boot:run -Dspring-boot.run.profiles=test

echo.
echo Waiting for application to start (15 seconds)...
ping localhost -n 16 > nul

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
echo 6. Add some test items using the form to verify calculations
echo.
echo ========================================

start "" "http://localhost:8082/spareparts"

echo.
echo Press any key to stop the application...
pause > nul

echo.
echo Stopping application...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":8082" ^| find "LISTENING"') do taskkill /f /pid %%a 2>nul

echo.
echo Test completed.
pause
