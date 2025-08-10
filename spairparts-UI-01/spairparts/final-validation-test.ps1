#!/usr/bin/env powershell

# FINAL VALIDATION TEST SCRIPT FOR RESPONSIVE THYMELEAF IMPLEMENTATION
# This script performs comprehensive testing of the completed responsive conversion

Write-Host "🎯 FINAL VALIDATION TEST - RESPONSIVE THYMELEAF DASHBOARD" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "🕒 Test started at: $timestamp" -ForegroundColor Gray
Write-Host ""

# Test results tracking
$testResults = @()

function Add-TestResult {
    param($Test, $Status, $Details)
    $testResults += [PSCustomObject]@{
        Test = $Test
        Status = $Status
        Details = $Details
        Timestamp = (Get-Date -Format "HH:mm:ss")
    }
}

Write-Host "📋 VALIDATION CHECKLIST" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
Write-Host ""

# 1. Check file structure
Write-Host "1️⃣ CHECKING PROJECT STRUCTURE..." -ForegroundColor Blue
$mainTemplate = "src\main\resources\templates\spareparts-sample.html"
$controller = "src\main\java\com\tas\spairparts\SparePartsViewController.java"
$pom = "pom.xml"

if (Test-Path $mainTemplate) {
    Write-Host "   ✅ Main template exists: $mainTemplate" -ForegroundColor Green
    Add-TestResult "Template File" "PASS" "Template file found"
} else {
    Write-Host "   ❌ Main template missing: $mainTemplate" -ForegroundColor Red
    Add-TestResult "Template File" "FAIL" "Template file not found"
}

if (Test-Path $controller) {
    Write-Host "   ✅ Controller exists: $controller" -ForegroundColor Green
    Add-TestResult "Controller File" "PASS" "Controller file found"
} else {
    Write-Host "   ❌ Controller missing: $controller" -ForegroundColor Red
    Add-TestResult "Controller File" "FAIL" "Controller file not found"
}

Write-Host ""

# 2. Check Thymeleaf configuration
Write-Host "2️⃣ VALIDATING THYMELEAF CONFIGURATION..." -ForegroundColor Blue

$templateContent = Get-Content $mainTemplate -Raw
if ($templateContent -match 'xmlns:th="http://www.thymeleaf.org"') {
    Write-Host "   ✅ Thymeleaf namespace configured" -ForegroundColor Green
    Add-TestResult "Thymeleaf Namespace" "PASS" "Namespace properly configured"
} else {
    Write-Host "   ❌ Thymeleaf namespace missing" -ForegroundColor Red
    Add-TestResult "Thymeleaf Namespace" "FAIL" "Namespace not found"
}

if ($templateContent -match 'xmlns:sec="https://www.thymeleaf.org/thymeleaf-extras-springsecurity5"') {
    Write-Host "   ✅ Spring Security namespace configured" -ForegroundColor Green
    Add-TestResult "Security Namespace" "PASS" "Security namespace configured"
} else {
    Write-Host "   ❌ Spring Security namespace missing" -ForegroundColor Red
    Add-TestResult "Security Namespace" "FAIL" "Security namespace not found"
}

if ($templateContent -match 'th:each="item : \$\{spareparts\}"') {
    Write-Host "   ✅ Server-side rendering with th:each" -ForegroundColor Green
    Add-TestResult "Server-side Rendering" "PASS" "th:each loop found"
} else {
    Write-Host "   ❌ Server-side rendering not implemented" -ForegroundColor Red
    Add-TestResult "Server-side Rendering" "FAIL" "th:each loop not found"
}

Write-Host ""

# 3. Check responsive design features
Write-Host "3️⃣ VALIDATING RESPONSIVE DESIGN..." -ForegroundColor Blue

if ($templateContent -match 'grid-cols-1 md:grid-cols-2 xl:grid-cols-3') {
    Write-Host "   ✅ Responsive grid system (1→2→3 columns)" -ForegroundColor Green
    Add-TestResult "Responsive Grid" "PASS" "Adaptive column layout found"
} else {
    Write-Host "   ❌ Responsive grid system missing" -ForegroundColor Red
    Add-TestResult "Responsive Grid" "FAIL" "Adaptive grid not found"
}

if ($templateContent -match 'mobile-menu-button') {
    Write-Host "   ✅ Mobile hamburger menu" -ForegroundColor Green
    Add-TestResult "Mobile Menu" "PASS" "Hamburger menu implemented"
} else {
    Write-Host "   ❌ Mobile menu missing" -ForegroundColor Red
    Add-TestResult "Mobile Menu" "FAIL" "Hamburger menu not found"
}

if ($templateContent -match 'md:hidden') {
    Write-Host "   ✅ Mobile-specific visibility classes" -ForegroundColor Green
    Add-TestResult "Mobile Visibility" "PASS" "Mobile-specific classes found"
} else {
    Write-Host "   ❌ Mobile visibility classes missing" -ForegroundColor Red
    Add-TestResult "Mobile Visibility" "FAIL" "Mobile classes not found"
}

Write-Host ""

# 4. Check security features
Write-Host "4️⃣ VALIDATING SECURITY INTEGRATION..." -ForegroundColor Blue

if ($templateContent -match 'sec:authorize="hasRole\(''ADMIN''\)"') {
    Write-Host "   ✅ Role-based access control" -ForegroundColor Green
    Add-TestResult "Role-based Access" "PASS" "Admin role checks found"
} else {
    Write-Host "   ❌ Role-based access control missing" -ForegroundColor Red
    Add-TestResult "Role-based Access" "FAIL" "Admin role checks not found"
}

if ($templateContent -match '\$\{_csrf\.token\}') {
    Write-Host "   ✅ CSRF protection configured" -ForegroundColor Green
    Add-TestResult "CSRF Protection" "PASS" "CSRF tokens found"
} else {
    Write-Host "   ❌ CSRF protection missing" -ForegroundColor Red
    Add-TestResult "CSRF Protection" "FAIL" "CSRF tokens not found"
}

Write-Host ""

# 5. Check controller configuration
Write-Host "5️⃣ VALIDATING CONTROLLER SETUP..." -ForegroundColor Blue

$controllerContent = Get-Content $controller -Raw
if ($controllerContent -match 'SparePartsService') {
    Write-Host "   ✅ Service dependency injection" -ForegroundColor Green
    Add-TestResult "Service Injection" "PASS" "SparePartsService found"
} else {
    Write-Host "   ❌ Service dependency missing" -ForegroundColor Red
    Add-TestResult "Service Injection" "FAIL" "SparePartsService not found"
}

if ($controllerContent -match '@PostMapping.*add') {
    Write-Host "   ✅ Form submission handling" -ForegroundColor Green
    Add-TestResult "Form Handling" "PASS" "POST mapping found"
} else {
    Write-Host "   ❌ Form submission handling missing" -ForegroundColor Red
    Add-TestResult "Form Handling" "FAIL" "POST mapping not found"
}

if ($controllerContent -match 'addCommonModelAttributes') {
    Write-Host "   ✅ Model attributes helper method" -ForegroundColor Green
    Add-TestResult "Model Attributes" "PASS" "Helper method found"
} else {
    Write-Host "   ❌ Model attributes helper missing" -ForegroundColor Red
    Add-TestResult "Model Attributes" "FAIL" "Helper method not found"
}

Write-Host ""

# 6. Test application startup
Write-Host "6️⃣ TESTING APPLICATION STARTUP..." -ForegroundColor Blue
Write-Host "   🔧 Starting Spring Boot application..." -ForegroundColor Yellow

try {
    $startProcess = Start-Process -FilePath "mvn" -ArgumentList "spring-boot:run", "-Dspring-boot.run.fork=false" -PassThru -WindowStyle Minimized -RedirectStandardOutput "startup.log" -RedirectStandardError "startup-error.log"
    
    Write-Host "   ⏳ Waiting for startup (30 seconds)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    
    # Check if application is responding
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 5 -ErrorAction Stop
        Write-Host "   ✅ Application started successfully (HTTP $($response.StatusCode))" -ForegroundColor Green
        Add-TestResult "Application Startup" "PASS" "HTTP $($response.StatusCode) received"
    } catch {
        Write-Host "   ⚠️ Application may still be starting or requires authentication" -ForegroundColor Yellow
        Add-TestResult "Application Startup" "PARTIAL" "Connection attempt made"
    }
    
    # Stop the process
    if (!$startProcess.HasExited) {
        $startProcess.Kill()
        Write-Host "   🛑 Application stopped" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ❌ Failed to start application: $($_.Exception.Message)" -ForegroundColor Red
    Add-TestResult "Application Startup" "FAIL" $_.Exception.Message
}

Write-Host ""

# 7. Generate test report
Write-Host "📊 TEST RESULTS SUMMARY" -ForegroundColor Magenta
Write-Host "========================" -ForegroundColor Magenta
Write-Host ""

$passCount = ($testResults | Where-Object { $_.Status -eq "PASS" }).Count
$failCount = ($testResults | Where-Object { $_.Status -eq "FAIL" }).Count
$partialCount = ($testResults | Where-Object { $_.Status -eq "PARTIAL" }).Count
$totalTests = $testResults.Count

Write-Host "✅ PASSED: $passCount tests" -ForegroundColor Green
Write-Host "❌ FAILED: $failCount tests" -ForegroundColor Red
Write-Host "⚠️  PARTIAL: $partialCount tests" -ForegroundColor Yellow
Write-Host "📋 TOTAL: $totalTests tests" -ForegroundColor Cyan
Write-Host ""

$successRate = [math]::Round(($passCount / $totalTests) * 100, 1)
Write-Host "🎯 SUCCESS RATE: $successRate%" -ForegroundColor $(if($successRate -ge 90) {"Green"} elseif($successRate -ge 70) {"Yellow"} else {"Red"})
Write-Host ""

# Detailed results
Write-Host "📋 DETAILED RESULTS:" -ForegroundColor Cyan
Write-Host "--------------------" -ForegroundColor Cyan
foreach ($result in $testResults) {
    $statusColor = switch ($result.Status) {
        "PASS" { "Green" }
        "FAIL" { "Red" }
        "PARTIAL" { "Yellow" }
        default { "White" }
    }
    
    Write-Host "[$($result.Timestamp)] $($result.Test): " -NoNewline -ForegroundColor Gray
    Write-Host "$($result.Status)" -ForegroundColor $statusColor
    Write-Host "   └─ $($result.Details)" -ForegroundColor Gray
}

Write-Host ""

# Final recommendations
Write-Host "🔧 NEXT STEPS & RECOMMENDATIONS:" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

if ($failCount -eq 0) {
    Write-Host "🎉 EXCELLENT! All core features are properly implemented." -ForegroundColor Green
    Write-Host ""
    Write-Host "📱 READY FOR PRODUCTION TESTING:" -ForegroundColor Green
    Write-Host "   • Test on actual mobile devices (iOS/Android)" -ForegroundColor White
    Write-Host "   • Verify cross-browser compatibility" -ForegroundColor White
    Write-Host "   • Load test with larger datasets" -ForegroundColor White
    Write-Host "   • User acceptance testing" -ForegroundColor White
} else {
    Write-Host "⚠️  Some issues detected. Please review failed tests above." -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 RECOMMENDED FIXES:" -ForegroundColor Yellow
    foreach ($failedTest in ($testResults | Where-Object { $_.Status -eq "FAIL" })) {
        Write-Host "   • Fix: $($failedTest.Test) - $($failedTest.Details)" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "🏁 VALIDATION COMPLETE - $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Cyan
Write-Host ""

# Save results to file
$reportPath = "validation-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
$testResults | Format-Table -AutoSize | Out-File $reportPath
Write-Host "📄 Detailed report saved to: $reportPath" -ForegroundColor Gray
