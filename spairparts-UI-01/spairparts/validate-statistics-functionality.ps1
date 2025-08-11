# Statistics Functionality Validation Script
# Run this script to validate the statistics functionality in production

Write-Host "🎯 Statistics Functionality Validation" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Function to test API endpoint
function Test-ApiEndpoint {
    param(
        [string]$Url,
        [string]$Description
    )
    
    try {
        Write-Host "Testing: $Description" -ForegroundColor Yellow
        $response = Invoke-RestMethod -Uri $Url -Method Get -TimeoutSec 10
        Write-Host "✅ SUCCESS: $Description" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ FAILED: $Description - $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to start application
function Start-Application {
    Write-Host "🚀 Starting Spring Boot Application..." -ForegroundColor Cyan
    
    # Change to project directory
    $projectPath = "e:\my-pro\spair-parts-pro\spairparts-UI-01\spairparts"
    Set-Location $projectPath
    
    # Start application in background
    Write-Host "Starting on port 8086..." -ForegroundColor Yellow
    $process = Start-Process -FilePath "mvn" -ArgumentList "spring-boot:run" -PassThru -WindowStyle Minimized
    
    # Wait for application to start
    Write-Host "Waiting for application to start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 15
    
    return $process
}

# Function to test statistics API
function Test-StatisticsApi {
    $baseUrl = "http://localhost:8086"
    $results = @()
    
    Write-Host "📊 Testing Statistics API Endpoints..." -ForegroundColor Cyan
    
    # Test health endpoint
    $results += Test-ApiEndpoint "$baseUrl/api/spareparts/health" "Health Check"
    
    # Test statistics endpoint
    $results += Test-ApiEndpoint "$baseUrl/api/spareparts/statistics" "Statistics Calculation"
    
    # Test items endpoint
    $results += Test-ApiEndpoint "$baseUrl/api/spareparts/items" "Items List"
    
    # Test low stock endpoint
    $results += Test-ApiEndpoint "$baseUrl/api/spareparts/low-stock" "Low Stock Items"
    
    return $results
}

# Function to validate statistics data
function Validate-StatisticsData {
    try {
        Write-Host "🔍 Validating Statistics Data..." -ForegroundColor Cyan
        
        $statsUrl = "http://localhost:8086/api/spareparts/statistics"
        $stats = Invoke-RestMethod -Uri $statsUrl -Method Get
        
        Write-Host "Statistics Data:" -ForegroundColor Yellow
        Write-Host "  Total Items: $($stats.totalItems)" -ForegroundColor White
        Write-Host "  Total Value: $($stats.totalValue)" -ForegroundColor White
        Write-Host "  Low Stock Items: $($stats.lowStockItems)" -ForegroundColor White
        Write-Host "  Average Price: $($stats.averagePrice)" -ForegroundColor White
        Write-Host "  Last Updated: $($stats.lastUpdated)" -ForegroundColor White
        
        # Validate data integrity
        $valid = $true
        
        if ($stats.totalItems -eq $null) {
            Write-Host "❌ Total Items is null" -ForegroundColor Red
            $valid = $false
        }
        
        if ($stats.totalValue -eq $null) {
            Write-Host "❌ Total Value is null" -ForegroundColor Red
            $valid = $false
        }
        
        if ($stats.lastUpdated -eq $null) {
            Write-Host "❌ Last Updated is null" -ForegroundColor Red
            $valid = $false
        }
        
        if ($valid) {
            Write-Host "✅ All statistics data is valid" -ForegroundColor Green
        }
        
        return $valid
    }
    catch {
        Write-Host "❌ Failed to validate statistics data: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Main execution
try {
    Write-Host "Starting validation process..." -ForegroundColor Cyan
    
    # Start application
    $appProcess = Start-Application
    
    # Test API endpoints
    $apiResults = Test-StatisticsApi
    
    # Validate statistics data
    $dataValid = Validate-StatisticsData
    
    # Summary
    Write-Host ""
    Write-Host "📋 VALIDATION SUMMARY" -ForegroundColor Cyan
    Write-Host "=====================" -ForegroundColor Cyan
    
    $passedTests = ($apiResults | Where-Object { $_ -eq $true }).Count
    $totalTests = $apiResults.Count
    
    Write-Host "API Tests: $passedTests/$totalTests passed" -ForegroundColor $(if ($passedTests -eq $totalTests) { "Green" } else { "Red" })
    Write-Host "Data Validation: $(if ($dataValid) { "PASSED" } else { "FAILED" })" -ForegroundColor $(if ($dataValid) { "Green" } else { "Red" })
    
    if ($passedTests -eq $totalTests -and $dataValid) {
        Write-Host ""
        Write-Host "🎉 ALL VALIDATIONS PASSED!" -ForegroundColor Green
        Write-Host "Statistics functionality is working correctly." -ForegroundColor Green
        Write-Host ""
        Write-Host "🌐 Access the dashboard at: http://localhost:8086" -ForegroundColor Cyan
        Write-Host "👤 Login with: admin/admin123" -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "❌ SOME VALIDATIONS FAILED" -ForegroundColor Red
        Write-Host "Please check the errors above." -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Press any key to stop the application..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    # Stop application
    if ($appProcess) {
        Write-Host "Stopping application..." -ForegroundColor Yellow
        Stop-Process -Id $appProcess.Id -Force -ErrorAction SilentlyContinue
    }
}
catch {
    Write-Host "❌ Validation failed with error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Validation complete!" -ForegroundColor Green
