#!/usr/bin/env pwsh
# Comprehensive test script for Thymeleaf responsive dashboard

Write-Host "🧪 Thymeleaf Responsive Dashboard - Test Suite" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Cyan

$baseUrl = "http://localhost:8080"
$testResults = @()

function Test-EndpointResponse {
    param($url, $description)
    
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $description - OK (200)" -ForegroundColor Green
            return @{ Test = $description; Status = "PASS"; Code = $response.StatusCode }
        } else {
            Write-Host "⚠️  $description - Status: $($response.StatusCode)" -ForegroundColor Yellow
            return @{ Test = $description; Status = "WARN"; Code = $response.StatusCode }
        }
    } catch {
        Write-Host "❌ $description - FAILED: $($_.Exception.Message)" -ForegroundColor Red
        return @{ Test = $description; Status = "FAIL"; Code = "N/A" }
    }
}

function Test-ThymeleafFeatures {
    param($content)
    
    $features = @{
        "Thymeleaf Namespace" = $content -match 'xmlns:th="http://www.thymeleaf.org"'
        "Spring Security Namespace" = $content -match 'xmlns:sec="http://www.thymeleaf.org/extras/spring-security"'
        "CSRF Meta Tags" = $content -match '_csrf.*th:content'
        "Responsive Meta Tag" = $content -match 'viewport.*width=device-width'
        "Tailwind CSS" = $content -match 'tailwindcss.com'
        "Server-side Rendering" = $content -match 'th:each.*spareparts'
        "Form Binding" = $content -match 'th:object.*newSparepart'
        "Admin Role Check" = $content -match "hasRole.*ROLE_ADMIN"
        "Mobile Menu Toggle" = $content -match 'toggleMobileMenu'
    }
    
    Write-Host "`n🔍 Thymeleaf Features Analysis:" -ForegroundColor Yellow
    foreach ($feature in $features.GetEnumerator()) {
        if ($feature.Value) {
            Write-Host "✅ $($feature.Key)" -ForegroundColor Green
        } else {
            Write-Host "❌ $($feature.Key)" -ForegroundColor Red
        }
    }
    
    return $features
}

# Check if application is running
Write-Host "🔍 Checking if application is running..." -ForegroundColor Yellow

try {
    $healthCheck = Invoke-WebRequest -Uri $baseUrl -Method GET -TimeoutSec 5
    Write-Host "✅ Application is running on $baseUrl" -ForegroundColor Green
} catch {
    Write-Host "❌ Application not running. Please start with: ./start-thymeleaf-dashboard.ps1" -ForegroundColor Red
    Write-Host "   Or manually run: mvn spring-boot:run" -ForegroundColor Yellow
    exit 1
}

# Test main endpoints
Write-Host "`n🌐 Testing Endpoints:" -ForegroundColor Yellow
$testResults += Test-EndpointResponse "$baseUrl/" "Home Page"
$testResults += Test-EndpointResponse "$baseUrl/dashboard" "Dashboard"
$testResults += Test-EndpointResponse "$baseUrl/spareparts-sample" "Sample Page"

# Test API endpoints
Write-Host "`n🔗 Testing API Endpoints:" -ForegroundColor Yellow
$testResults += Test-EndpointResponse "$baseUrl/api/spareparts" "Spare Parts API"

# Analyze main page content
Write-Host "`n📄 Analyzing Page Content:" -ForegroundColor Yellow
try {
    $mainPageContent = (Invoke-WebRequest -Uri $baseUrl).Content
    $features = Test-ThymeleafFeatures $mainPageContent
    
    # Check responsive classes
    Write-Host "`n📱 Responsive Design Analysis:" -ForegroundColor Yellow
    $responsiveFeatures = @{
        "Mobile Grid (grid-cols-1)" = $mainPageContent -match 'grid-cols-1'
        "Tablet Grid (md:grid-cols-2)" = $mainPageContent -match 'md:grid-cols-2'
        "Desktop Grid (lg:grid-cols-3)" = $mainPageContent -match 'lg:grid-cols-3'
        "Mobile Menu (md:hidden)" = $mainPageContent -match 'md:hidden'
        "Responsive Padding" = $mainPageContent -match 'p-4.*md:p-'
        "Mobile-first Typography" = $mainPageContent -match 'text-.*md:text-'
    }
    
    foreach ($resp in $responsiveFeatures.GetEnumerator()) {
        if ($resp.Value) {
            Write-Host "✅ $($resp.Key)" -ForegroundColor Green
        } else {
            Write-Host "❌ $($resp.Key)" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "❌ Failed to analyze page content: $($_.Exception.Message)" -ForegroundColor Red
}

# Test Summary
Write-Host "`n📊 Test Summary:" -ForegroundColor Cyan
$passCount = ($testResults | Where-Object { $_.Status -eq "PASS" }).Count
$failCount = ($testResults | Where-Object { $_.Status -eq "FAIL" }).Count
$warnCount = ($testResults | Where-Object { $_.Status -eq "WARN" }).Count

Write-Host "✅ Passed: $passCount" -ForegroundColor Green
Write-Host "⚠️  Warnings: $warnCount" -ForegroundColor Yellow
Write-Host "❌ Failed: $failCount" -ForegroundColor Red

# Manual test instructions
Write-Host "`n🖱️  Manual Testing Instructions:" -ForegroundColor Cyan
Write-Host "1. Open browser to: $baseUrl" -ForegroundColor White
Write-Host "2. Login with: user/user123 or admin/admin123" -ForegroundColor White
Write-Host "3. Test responsive design:" -ForegroundColor White
Write-Host "   • Desktop (>1024px): 3-column grid" -ForegroundColor Gray
Write-Host "   • Tablet (768-1024px): 2-column grid" -ForegroundColor Gray
Write-Host "   • Mobile (<768px): 1-column + hamburger menu" -ForegroundColor Gray
Write-Host "4. Test add form functionality" -ForegroundColor White
Write-Host "5. Test admin features (edit/delete buttons)" -ForegroundColor White

Write-Host "`n🎉 Thymeleaf Responsive Dashboard Testing Complete!" -ForegroundColor Green