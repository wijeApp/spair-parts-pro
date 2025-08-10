#!/usr/bin/env powershell

# QUICK START SCRIPT - RESPONSIVE THYMELEAF DASHBOARD
# Run this script to immediately test the completed responsive implementation

param(
    [switch]$SkipTests,
    [switch]$OpenBrowser
)

Write-Host "🚀 QUICK START - RESPONSIVE THYMELEAF DASHBOARD" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "🕒 Started at: $timestamp" -ForegroundColor Gray
Write-Host ""

# Check if we're in the right directory
if (!(Test-Path "pom.xml")) {
    Write-Host "❌ ERROR: pom.xml not found. Please run this script from the project root directory." -ForegroundColor Red
    Write-Host "📁 Expected location: e:\my-pro\spair-parts-pro\spairparts-UI-01\spairparts" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Project directory confirmed" -ForegroundColor Green
Write-Host ""

# Quick validation if not skipped
if (!$SkipTests) {
    Write-Host "🔍 QUICK VALIDATION..." -ForegroundColor Blue
    
    # Check key files
    $mainTemplate = "src\main\resources\templates\spareparts-sample.html"
    $controller = "src\main\java\com\tas\spairparts\SparePartsViewController.java"
    
    if (Test-Path $mainTemplate) {
        Write-Host "   ✅ Responsive template found" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Template missing: $mainTemplate" -ForegroundColor Red
        exit 1
    }
    
    if (Test-Path $controller) {
        Write-Host "   ✅ Enhanced controller found" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Controller missing: $controller" -ForegroundColor Red
        exit 1
    }
    
    # Quick compile test
    Write-Host "   🔧 Testing compilation..." -ForegroundColor Yellow
    $compileResult = & mvn compile -q 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Compilation successful" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Compilation failed" -ForegroundColor Red
        Write-Host "   📄 Error details:" -ForegroundColor Gray
        Write-Host $compileResult -ForegroundColor Red
        exit 1
    }
    
    Write-Host "   🎯 All validations passed!" -ForegroundColor Green
    Write-Host ""
}

# Start the application
Write-Host "🚀 STARTING SPRING BOOT APPLICATION..." -ForegroundColor Blue
Write-Host ""
Write-Host "📱 RESPONSIVE FEATURES READY:" -ForegroundColor Green
Write-Host "   • Mobile-first responsive design" -ForegroundColor White
Write-Host "   • Hamburger menu for mobile navigation" -ForegroundColor White
Write-Host "   • Adaptive grid layouts (1/2/3 columns)" -ForegroundColor White
Write-Host "   • Server-side Thymeleaf rendering" -ForegroundColor White
Write-Host "   • Spring Security role-based access" -ForegroundColor White
Write-Host "   • CSRF protection enabled" -ForegroundColor White
Write-Host ""

Write-Host "🌐 APPLICATION WILL BE AVAILABLE AT:" -ForegroundColor Magenta
Write-Host "   http://localhost:8080/spareparts/sample" -ForegroundColor Cyan
Write-Host ""

Write-Host "📱 TESTING BREAKPOINTS:" -ForegroundColor Yellow
Write-Host "   📱 Mobile: < 768px (hamburger menu)" -ForegroundColor White
Write-Host "   📟 Tablet: 768px - 1024px (2 columns)" -ForegroundColor White
Write-Host "   🖥️  Desktop: > 1024px (3 columns)" -ForegroundColor White
Write-Host ""

Write-Host "⏳ Starting application (this may take 30-60 seconds)..." -ForegroundColor Yellow
Write-Host "💡 TIP: Use Ctrl+C to stop the application" -ForegroundColor Gray
Write-Host ""

# Open browser automatically if requested
if ($OpenBrowser) {
    Write-Host "🌐 Browser will open automatically once the application starts..." -ForegroundColor Cyan
    
    # Start application in background and wait for it to be ready
    $job = Start-Job -ScriptBlock {
        Set-Location $args[0]
        & mvn spring-boot:run -Dspring-boot.run.fork=false
    } -ArgumentList (Get-Location).Path
    
    # Wait for application to start (check every 5 seconds for up to 60 seconds)
    $maxWaitTime = 60
    $waitTime = 0
    $applicationReady = $false
    
    Write-Host "⏳ Waiting for application startup..." -ForegroundColor Yellow
    
    while ($waitTime -lt $maxWaitTime -and !$applicationReady) {
        Start-Sleep -Seconds 5
        $waitTime += 5
        
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/spareparts/sample" -TimeoutSec 3 -ErrorAction Stop
            $applicationReady = $true
            Write-Host "✅ Application is ready!" -ForegroundColor Green
        } catch {
            Write-Host "⏳ Still starting... ($waitTime/$maxWaitTime seconds)" -ForegroundColor Yellow
        }
    }
    
    if ($applicationReady) {
        Write-Host "🌐 Opening browser..." -ForegroundColor Cyan
        Start-Process "http://localhost:8080/spareparts/sample"
    } else {
        Write-Host "⚠️  Application may still be starting. Try opening the browser manually." -ForegroundColor Yellow
        Write-Host "🌐 URL: http://localhost:8080/spareparts/sample" -ForegroundColor Cyan
    }
    
    # Wait for the background job to complete
    Wait-Job $job
    Remove-Job $job
    
} else {
    # Run application in foreground
    Write-Host "🔥 STARTING APPLICATION..." -ForegroundColor Green
    Write-Host ""
    
    try {
        & mvn spring-boot:run -Dspring-boot.run.fork=false
    } catch {
        Write-Host ""
        Write-Host "❌ Application startup failed: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "🏁 Session completed at $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Cyan
