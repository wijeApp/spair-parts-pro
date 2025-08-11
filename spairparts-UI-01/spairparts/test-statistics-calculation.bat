@echo off
echo =============================================================
echo TESTING STATISTICS CALCULATION FIX
echo =============================================================
echo.

echo Checking MySQL status...
sc query MySQL >nul 2>&1
if %errorlevel%==0 (
    echo ✅ MySQL service found
) else (
    echo ❌ MySQL service not found - please start MySQL first
    echo Try: net start mysql
    pause
    exit /b 1
)

echo.
echo Starting application with statistics calculation fix...
echo Check browser console (F12) for debug messages
echo.

echo Starting Spring Boot application...
start "Spring Boot App" cmd /k "mvn spring-boot:run -Dspring-boot.run.profiles=dev"

echo Waiting for application to start...
timeout /t 10 /nobreak >nul

echo Opening browser...
start http://localhost:8080/dashboard

echo.
echo =============================================================
echo WHAT TO CHECK:
echo ✅ Statistics cards show correct non-zero values
echo ✅ Browser console shows "Successfully extracted from item X"
echo ✅ Console shows "Final calculated statistics"
echo ❌ If still 0, check console for errors
echo =============================================================
echo.
pause
