# Test Script for Statistics Calculation Fix
# This script tests the calculateInitialStats() function fix

Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "TESTING STATISTICS CALCULATION FIX" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

# Check if MySQL is running
Write-Host "1. Checking MySQL Service Status..." -ForegroundColor Yellow
$mysqlService = Get-Service -Name "MySQL*" -ErrorAction SilentlyContinue
if ($mysqlService -and $mysqlService.Status -eq "Running") {
    Write-Host "✅ MySQL service is running" -ForegroundColor Green
} else {
    Write-Host "❌ MySQL service is not running" -ForegroundColor Red
    Write-Host "💡 Please start MySQL service first" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Try one of these commands:" -ForegroundColor Yellow
    Write-Host "  net start mysql" -ForegroundColor Gray
    Write-Host "  .\start-mysql.bat" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

# Check if application directory exists
Write-Host ""
Write-Host "2. Checking Project Structure..." -ForegroundColor Yellow
$currentDir = Get-Location
$pomFile = Join-Path $currentDir "pom.xml"
$templateFile = Join-Path $currentDir "src\main\resources\templates\spareparts-responsive.html"

if (Test-Path $pomFile) {
    Write-Host "✅ Found pom.xml" -ForegroundColor Green
} else {
    Write-Host "❌ pom.xml not found" -ForegroundColor Red
    exit 1
}

if (Test-Path $templateFile) {
    Write-Host "✅ Found spareparts-responsive.html template" -ForegroundColor Green
} else {
    Write-Host "❌ Template file not found" -ForegroundColor Red
    exit 1
}

# Check database configuration
Write-Host ""
Write-Host "3. Checking Database Configuration..." -ForegroundColor Yellow
$configFile = Join-Path $currentDir "src\main\resources\application.properties"
if (Test-Path $configFile) {
    $config = Get-Content $configFile
    $dbUrl = $config | Where-Object { $_ -match "spring.datasource.url" }
    $dbUser = $config | Where-Object { $_ -match "spring.datasource.username" }
    
    if ($dbUrl -like "*localhost:3306/spareparts_prod*") {
        Write-Host "✅ Database URL configured for localhost" -ForegroundColor Green
    } else {
        Write-Host "❌ Database URL not configured properly" -ForegroundColor Red
        Write-Host "Current: $dbUrl" -ForegroundColor Gray
    }
    
    if ($dbUser -like "*sa*") {
        Write-Host "✅ Database username configured" -ForegroundColor Green
    } else {
        Write-Host "❌ Database username not configured properly" -ForegroundColor Red
    }
} else {
    Write-Host "❌ application.properties not found" -ForegroundColor Red
}

# Check JavaScript function in template
Write-Host ""
Write-Host "4. Checking JavaScript Function Fix..." -ForegroundColor Yellow
if (Test-Path $templateFile) {
    $templateContent = Get-Content $templateFile -Raw
    
    # Check for the fixed selectors
    if ($templateContent -match 'span\[class\*="text-xl"\]\[class\*="font-bold"\]\[class\*="text-primary"\]') {
        Write-Host "✅ Found updated price selector" -ForegroundColor Green
    } else {
        Write-Host "❌ Price selector not updated" -ForegroundColor Red
    }
    
    if ($templateContent -match 'div\[class\*="bg-gray-100"\]\[class\*="px-2"\]\[class\*="py-1"\]\[class\*="rounded-full"\]') {
        Write-Host "✅ Found updated stock selector" -ForegroundColor Green
    } else {
        Write-Host "❌ Stock selector not updated" -ForegroundColor Red
    }
    
    if ($templateContent -match 'calculateInitialStatsAlternative') {
        Write-Host "✅ Found alternative calculation method" -ForegroundColor Green
    } else {
        Write-Host "❌ Alternative calculation method not found" -ForegroundColor Red
    }
    
    if ($templateContent -match 'priceMatch.*stockMatch') {
        Write-Host "✅ Found fallback text extraction" -ForegroundColor Green
    } else {
        Write-Host "❌ Fallback extraction not found" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "5. Starting Application..." -ForegroundColor Yellow
Write-Host "This will compile and start the Spring Boot application with MySQL" -ForegroundColor Gray
Write-Host ""

# Start the application
Write-Host "Executing: mvn spring-boot:run -Dspring-boot.run.profiles=dev" -ForegroundColor Gray
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$currentDir'; Write-Host 'Starting Spring Boot Application...' -ForegroundColor Green; mvn spring-boot:run -Dspring-boot.run.profiles=dev"

# Wait a moment then open browser
Start-Sleep -Seconds 3
Write-Host ""
Write-Host "6. Testing Instructions:" -ForegroundColor Yellow
Write-Host "   • The application is starting in a new window" -ForegroundColor White
Write-Host "   • Wait for 'Started SpairpartsApplication' message" -ForegroundColor White
Write-Host "   • Then open: http://localhost:8080/dashboard" -ForegroundColor White
Write-Host "   • Check browser console (F12) for debug messages" -ForegroundColor White
Write-Host "   • Look for statistics calculations in console" -ForegroundColor White
Write-Host ""

Write-Host "7. What to Look For:" -ForegroundColor Yellow
Write-Host "   ✅ Statistics cards show non-zero values" -ForegroundColor Green
Write-Host "   ✅ Console shows 'Successfully extracted from item X'" -ForegroundColor Green
Write-Host "   ✅ Console shows 'Final calculated statistics'" -ForegroundColor Green
Write-Host "   ❌ If still showing 0, check console for error messages" -ForegroundColor Red
Write-Host ""

# Wait a bit more then try to open browser
Start-Sleep -Seconds 5
Write-Host "Opening browser..." -ForegroundColor Green
try {
    Start-Process "http://localhost:8080/dashboard"
} catch {
    Write-Host "Could not open browser automatically. Please open: http://localhost:8080/dashboard" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "TEST SCRIPT COMPLETED" -ForegroundColor Cyan
Write-Host "Monitor the application window and browser console for results" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
