@echo off
:: QUICK START BATCH FILE - RESPONSIVE THYMELEAF DASHBOARD
:: Double-click this file to start the responsive dashboard

title Responsive Thymeleaf Dashboard - Quick Start

echo.
echo ========================================
echo   RESPONSIVE THYMELEAF DASHBOARD
echo ========================================
echo.

echo [INFO] Starting responsive Thymeleaf dashboard...
echo [INFO] Features ready:
echo   - Mobile-first responsive design
echo   - Hamburger menu for mobile navigation  
echo   - Adaptive grid layouts (1/2/3 columns)
echo   - Server-side Thymeleaf rendering
echo   - Spring Security integration
echo   - CSRF protection
echo.

echo [INFO] Application will be available at:
echo   http://localhost:8080/spareparts/sample
echo.

echo [INFO] Testing breakpoints:
echo   Mobile: ^< 768px (hamburger menu)
echo   Tablet: 768px - 1024px (2 columns)  
echo   Desktop: ^> 1024px (3 columns)
echo.

echo [INFO] Starting Spring Boot application...
echo [TIP] Use Ctrl+C to stop the application
echo.

:: Check if pom.xml exists
if not exist "pom.xml" (
    echo [ERROR] pom.xml not found!
    echo [ERROR] Please run this script from the project root directory.
    echo [ERROR] Expected: e:\my-pro\spair-parts-pro\spairparts-UI-01\spairparts
    pause
    exit /b 1
)

:: Start the application
call mvn spring-boot:run -Dspring-boot.run.fork=false

echo.
echo [INFO] Application stopped.
pause
