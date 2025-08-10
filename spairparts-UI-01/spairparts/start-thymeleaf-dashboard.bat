@echo off
echo.
echo ========================================
echo  Thymeleaf Responsive Dashboard Starter
echo ========================================
echo.
echo Starting Spare Parts Dashboard...
echo.
echo Project Features:
echo  - Responsive Thymeleaf templates
echo  - Mobile-first design
echo  - Spring Boot integration
echo  - Admin role-based features
echo.
echo Login Credentials:
echo  Regular User: user / user123
echo  Admin User:   admin / admin123
echo.
echo Starting on: http://localhost:8080
echo.
echo Press Ctrl+C to stop the application
echo ========================================
echo.

REM Navigate to project directory
cd /d "e:\my-pro\spair-parts-pro\spairparts-UI-01\spairparts"

REM Check if Maven is available
where mvn >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Maven not found in PATH
    echo Please install Maven and add it to your PATH
    pause
    exit /b 1
)

REM Clean and compile
echo Building project...
mvn clean compile
if %errorlevel% neq 0 (
    echo ERROR: Build failed
    pause
    exit /b 1
)

echo.
echo Build successful! Starting application...
echo.

REM Start Spring Boot application
mvn spring-boot:run

pause