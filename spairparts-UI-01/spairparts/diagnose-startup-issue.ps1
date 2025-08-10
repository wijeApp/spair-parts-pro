#!/usr/bin/env powershell

# DIAGNOSTIC SCRIPT - APPLICATION STARTUP TROUBLESHOOTING
# This script helps diagnose the Spring Boot startup issue

Write-Host "🔍 DIAGNOSING APPLICATION STARTUP ISSUE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check basic project structure
Write-Host "1️⃣ CHECKING PROJECT STRUCTURE..." -ForegroundColor Blue

if (Test-Path "pom.xml") {
    Write-Host "   ✅ pom.xml found" -ForegroundColor Green
} else {
    Write-Host "   ❌ pom.xml missing" -ForegroundColor Red
    exit 1
}

if (Test-Path "src\main\java") {
    Write-Host "   ✅ Java source directory exists" -ForegroundColor Green
} else {
    Write-Host "   ❌ Java source directory missing" -ForegroundColor Red
    exit 1
}

if (Test-Path "src\main\resources\application.properties") {
    Write-Host "   ✅ Application properties found" -ForegroundColor Green
} else {
    Write-Host "   ❌ Application properties missing" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Check compilation
Write-Host "2️⃣ TESTING COMPILATION..." -ForegroundColor Blue

try {
    $compileOutput = mvn compile -q 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Compilation successful" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Compilation failed" -ForegroundColor Red
        Write-Host "   📄 Error:" -ForegroundColor Gray
        Write-Host $compileOutput -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "   ❌ Compilation error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Check application.properties
Write-Host "3️⃣ CHECKING CONFIGURATION..." -ForegroundColor Blue

$appProperties = Get-Content "src\main\resources\application.properties" -Raw
if ($appProperties -match "server\.port=(\d+)") {
    $port = $Matches[1]
    Write-Host "   ✅ Server port configured: $port" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  No port configured, will use default 8080" -ForegroundColor Yellow
    $port = "8080"
}

if ($appProperties -match "spring\.datasource\.url") {
    Write-Host "   ✅ Database URL configured" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  No database URL configured" -ForegroundColor Yellow
}

Write-Host ""

# Test database connection
Write-Host "4️⃣ TESTING DATABASE CONNECTION..." -ForegroundColor Blue

Write-Host "   🔗 Attempting to start application for 20 seconds..." -ForegroundColor Yellow

# Start application in background job
$job = Start-Job -ScriptBlock {
    Set-Location $args[0]
    mvn spring-boot:run -Dspring-boot.run.fork=false 2>&1
} -ArgumentList (Get-Location).Path

# Wait for startup
Start-Sleep -Seconds 15

# Check if application is responding
try {
    $response = Invoke-WebRequest -Uri "http://localhost:$port" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "   ✅ Application started successfully! (HTTP $($response.StatusCode))" -ForegroundColor Green
    $startupSuccess = $true
} catch {
    Write-Host "   ⚠️  Application may still be starting or has an issue: $($_.Exception.Message)" -ForegroundColor Yellow
    $startupSuccess = $false
}

# Check job output for errors
$jobOutput = Receive-Job $job -Keep

if ($jobOutput -match "ERROR|Exception|Failed") {
    Write-Host "   ❌ Startup errors detected:" -ForegroundColor Red
    $errorLines = $jobOutput | Where-Object { $_ -match "ERROR|Exception|Failed" } | Select-Object -First 5
    foreach ($line in $errorLines) {
        Write-Host "      $line" -ForegroundColor Red
    }
} elseif ($jobOutput -match "Started.*Application.*in.*seconds") {
    Write-Host "   ✅ Application startup completed successfully" -ForegroundColor Green
    $startupSuccess = $true
}

# Clean up
Stop-Job $job -ErrorAction SilentlyContinue
Remove-Job $job -ErrorAction SilentlyContinue

Write-Host ""

# Summary and recommendations
Write-Host "📋 DIAGNOSTIC SUMMARY" -ForegroundColor Magenta
Write-Host "=====================" -ForegroundColor Magenta

if ($startupSuccess) {
    Write-Host "✅ APPLICATION IS WORKING CORRECTLY!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Access your application at: http://localhost:$port/spareparts/sample" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📱 To test responsive features:" -ForegroundColor Yellow
    Write-Host "   • Open browser developer tools (F12)" -ForegroundColor White
    Write-Host "   • Toggle device simulation" -ForegroundColor White
    Write-Host "   • Test different screen sizes" -ForegroundColor White
} else {
    Write-Host "⚠️  POTENTIAL ISSUES DETECTED" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔧 TROUBLESHOOTING STEPS:" -ForegroundColor Yellow
    Write-Host "   1. Check database connection (MySQL server running?)" -ForegroundColor White
    Write-Host "   2. Verify port $port is not in use" -ForegroundColor White
    Write-Host "   3. Check firewall settings" -ForegroundColor White
    Write-Host "   4. Try running with: mvn spring-boot:run -Dspring-boot.run.fork=false" -ForegroundColor White
    Write-Host ""
    Write-Host "📄 Full startup log available in job output above" -ForegroundColor Gray
}

Write-Host ""
Write-Host "🔧 NEXT STEPS:" -ForegroundColor Cyan
if ($startupSuccess) {
    Write-Host "   • The responsive Thymeleaf dashboard is ready to use!" -ForegroundColor Green
    Write-Host "   • Test mobile responsiveness with browser dev tools" -ForegroundColor Green
    Write-Host "   • Verify admin functionality with appropriate user roles" -ForegroundColor Green
} else {
    Write-Host "   • Review the error messages above" -ForegroundColor Yellow
    Write-Host "   • Check database connectivity" -ForegroundColor Yellow
    Write-Host "   • Verify application.properties configuration" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🏁 Diagnosis complete - $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Gray
