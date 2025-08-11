@echo off
echo ========================================
echo Testing calculateInitialStats Fix - Updated Database
echo ========================================

echo.
echo Database Configuration:
echo - Using spareparts_prod database
echo - Development profile (Railway MySQL)
echo.

echo This script will:
echo 1. Start the Spring Boot application with spareparts_prod database
echo 2. Open browser with developer console
echo 3. Check if statistics are calculated correctly
echo.

echo Starting the application...
start "" /B mvn spring-boot:run -Dspring-boot.run.profiles=dev

echo.
echo Waiting for application to start (20 seconds)...
ping localhost -n 21 > nul

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
echo    - Total Items should show correct count (from spareparts_prod DB)
echo    - Total Value should be calculated
echo    - Low Stock Items should be counted
echo    - Average Price should be calculated
echo.
echo 4. Test search functionality:
echo    - Search for an item name
echo    - Total Items should update to filtered count
echo    - Clear search - count should restore
echo.
echo 5. Debug information:
echo    - Look for DOM structure analysis in console
echo    - Check if items are being properly extracted
echo    - Verify price and quantity extraction
echo.
echo 6. Add test items if needed:
echo    - Use the admin form to add items
echo    - Watch statistics update in real-time
echo.
echo ========================================

start "" "http://localhost:8082/spareparts"

echo.
echo Application running on: http://localhost:8082/spareparts
echo Database: spareparts_prod (Railway MySQL)
echo.
echo Press any key to stop the application...
pause > nul

echo.
echo Stopping application...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":8082" ^| find "LISTENING"') do taskkill /f /pid %%a 2>nul

echo.
echo Test completed.
pause
