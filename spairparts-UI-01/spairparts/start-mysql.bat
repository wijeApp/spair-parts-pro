@echo off
REM Spare Parts Management System - Startup Script for MySQL

echo ========================================
echo Spare Parts Management System
echo Database: MySQL
echo ========================================

echo.
echo Choose environment:
echo 1. Development (dev profile)
echo 2. Production (prod profile)  
echo 3. Default (main application.properties)
echo.

set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo Starting in Development mode...
    mvn spring-boot:run -Dspring-boot.run.profiles=dev
) else if "%choice%"=="2" (
    echo Starting in Production mode...
    mvn spring-boot:run -Dspring-boot.run.profiles=prod
) else if "%choice%"=="3" (
    echo Starting with default configuration...
    mvn spring-boot:run
) else (
    echo Invalid choice. Starting with default configuration...
    mvn spring-boot:run
)

pause
