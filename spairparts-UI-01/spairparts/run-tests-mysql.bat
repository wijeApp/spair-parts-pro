@echo off
REM Setup MySQL test database and run tests

echo ========================================
echo Setting up MySQL Test Database
echo ========================================

REM Create test database
echo Creating test database...
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS spareparts_test;"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to create test database!
    echo Please ensure:
    echo 1. MySQL server is running
    echo 2. Root password is correct
    echo 3. You have CREATE DATABASE privileges
    echo.
    pause
    exit /b 1
)

echo Test database created successfully!
echo.

echo ========================================
echo Running Tests
echo ========================================

REM Run Maven tests
mvn test

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Tests failed!
    echo Check the error messages above for details.
    echo.
) else (
    echo.
    echo SUCCESS: All tests passed!
    echo.
)

pause
