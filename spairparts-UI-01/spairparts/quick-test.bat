@echo off
REM Quick test runner - assumes MySQL is already set up

echo ========================================
echo Running MySQL Tests
echo ========================================

echo Ensuring test database exists...
mysql -u root -e "CREATE DATABASE IF NOT EXISTS spareparts_test;" 2>nul

echo Running tests with MySQL...
mvn test -Dspring.profiles.active=test

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Tests failed! 
    echo.
    echo Possible issues:
    echo 1. MySQL server not running
    echo 2. Database connection failed
    echo 3. Test database doesn't exist
    echo.
    echo Try running: mysql -u root -e "CREATE DATABASE spareparts_test;"
    echo.
) else (
    echo.
    echo ✅ All tests passed!
    echo.
)

pause
