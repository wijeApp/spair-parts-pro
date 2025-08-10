@echo off
REM Spare Parts Dashboard - MySQL Integration Test

echo ========================================
echo Spare Parts Dashboard - MySQL Integration
echo ========================================

echo.
echo Step 1: Checking MySQL connection...
mysql -u root -e "SELECT 'MySQL is running' as Status;" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo ❌ MySQL is not running or not accessible
    echo Please start MySQL server first
    echo.
    pause
    exit /b 1
)

echo ✅ MySQL server is running

echo.
echo Step 2: Ensuring database exists...
mysql -u root -e "CREATE DATABASE IF NOT EXISTS spairparts_db; USE spairparts_db; SELECT 'Database ready' as Status;" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to create/access database
    pause
    exit /b 1
)

echo ✅ Database spairparts_db is ready

echo.
echo Step 3: Starting Spring Boot application...
echo This will:
echo - Connect to MySQL database
echo - Create tables automatically (JPA)
echo - Load sample data
echo - Start web server on port 8082
echo.

mvn spring-boot:run

echo.
echo Application started! 
echo.
echo 📊 Dashboard: http://localhost:8082/spareparts-sample
echo 🔗 API Test: http://localhost:8082/api/spareparts
echo 🗄️ DB Test: http://localhost:8082/api/test/db-connection
echo.
pause
