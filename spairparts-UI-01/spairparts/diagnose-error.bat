@echo off
echo.
echo =============================================
echo   SPRING BOOT ERROR DIAGNOSIS
echo =============================================
echo.

echo [INFO] Checking MySQL service status...
net start | findstr /i "mysql" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL service is running
    set MYSQL_RUNNING=true
) else (
    echo ❌ MySQL service is NOT running
    set MYSQL_RUNNING=false
)

echo.
echo [INFO] Testing database connections...

if "%MYSQL_RUNNING%"=="true" (
    echo Testing MySQL connection...
    mysql --version >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ MySQL client is available
    ) else (
        echo ❌ MySQL client not found in PATH
    )
) else (
    echo ⚠️  MySQL is not running - will use H2 for testing
)

echo.
echo [INFO] Trying different startup options...

if "%MYSQL_RUNNING%"=="true" (
    echo.
    echo Option 1: Starting with MySQL (Development Profile)
    echo Command: mvn spring-boot:run -Dspring-boot.run.profiles=dev
    echo.
    echo ⚠️  If this fails, make sure:
    echo    - MySQL database 'spareparts_db' exists
    echo    - Username/password in application-dev.properties are correct
    echo    - MySQL is accepting connections on port 3306
    echo.
    pause
    mvn spring-boot:run -Dspring-boot.run.profiles=dev
) else (
    echo.
    echo Option 1: Starting with H2 (Test Profile)
    echo Command: mvn spring-boot:run -Dspring-boot.run.profiles=test
    echo.
    echo ✅ This should work without any database setup
    echo    H2 Console: http://localhost:8082/h2-console
    echo    JDBC URL: jdbc:h2:mem:testdb
    echo    Username: sa
    echo    Password: (leave empty)
    echo.
    pause
    mvn spring-boot:run -Dspring-boot.run.profiles=test
)

echo.
echo =============================================
echo   TROUBLESHOOTING GUIDE
echo =============================================
echo.

if "%MYSQL_RUNNING%"=="false" (
    echo ❌ MYSQL NOT RUNNING - SOLUTIONS:
    echo.
    echo 1. Install MySQL:
    echo    - Download from: https://dev.mysql.com/downloads/mysql/
    echo    - Install and start the service
    echo.
    echo 2. Start MySQL service:
    echo    - Run: net start mysql
    echo    - Or use Services.msc to start MySQL service
    echo.
    echo 3. Create database and user:
    echo    - Run: mysql -u root -p ^< src\main\resources\database-setup.sql
    echo.
    echo 4. Update credentials in application-dev.properties
    echo.
    echo 5. Use H2 for testing (temporary):
    echo    - Run: mvn spring-boot:run -Dspring-boot.run.profiles=test
    echo.
) else (
    echo ✅ MYSQL IS RUNNING - POTENTIAL ISSUES:
    echo.
    echo 1. Database doesn't exist:
    echo    - Run: mysql -u root -p ^< src\main\resources\database-setup.sql
    echo.
    echo 2. Wrong credentials:
    echo    - Check application-dev.properties
    echo    - Verify: mysql -u spareparts_user -p spareparts_db
    echo.
    echo 3. Connection refused:
    echo    - Check MySQL is on port 3306
    echo    - Check firewall settings
    echo.
)

echo =============================================
pause
