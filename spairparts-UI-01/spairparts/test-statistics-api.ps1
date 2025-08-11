# Test Statistics API Endpoint
Write-Host "🎯 Testing Statistics API Functionality" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# Create a session for maintaining cookies
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

try {
    # Step 1: Get login page to get CSRF token
    Write-Host "Getting login page..." -ForegroundColor Yellow
    $loginPage = Invoke-WebRequest -Uri "http://localhost:8086/login" -WebSession $session -UseBasicParsing
    
    # Extract CSRF token from the page
    if ($loginPage.Content -match '_csrf.*?value="([^"]+)"') {
        $csrfToken = $matches[1]
        Write-Host "✅ CSRF Token obtained" -ForegroundColor Green
    } else {
        Write-Host "❌ Could not find CSRF token" -ForegroundColor Red
        exit 1
    }
    
    # Step 2: Login with credentials
    Write-Host "Logging in as admin..." -ForegroundColor Yellow
    $loginBody = "username=admin&password=admin123&_csrf=$csrfToken"
    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8086/login" -Method Post -Body $loginBody -ContentType "application/x-www-form-urlencoded" -WebSession $session -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
    
    if ($loginResponse.StatusCode -eq 302 -or $loginResponse.StatusCode -eq 200) {
        Write-Host "✅ Login successful!" -ForegroundColor Green
    } else {
        Write-Host "❌ Login failed with status: $($loginResponse.StatusCode)" -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Write-Host "📊 Testing API Endpoints:" -ForegroundColor Cyan
    Write-Host "=========================" -ForegroundColor Cyan
    
    # Step 3: Test statistics endpoint
    Write-Host "1. Testing /api/spareparts/statistics..." -ForegroundColor Yellow
    try {
        $statsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/spareparts/statistics" -WebSession $session
        Write-Host "✅ Statistics endpoint working!" -ForegroundColor Green
        Write-Host "   Total Items: $($statsResponse.totalItems)" -ForegroundColor White
        Write-Host "   Total Value: $($statsResponse.totalValue)" -ForegroundColor White
        Write-Host "   Low Stock Items: $($statsResponse.lowStockItems)" -ForegroundColor White
        Write-Host "   Average Price: $($statsResponse.averagePrice)" -ForegroundColor White
        Write-Host "   Last Updated: $($statsResponse.lastUpdated)" -ForegroundColor White
    } catch {
        Write-Host "❌ Statistics endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    
    # Step 4: Test items endpoint
    Write-Host "2. Testing /api/spareparts/items..." -ForegroundColor Yellow
    try {
        $itemsResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/spareparts" -WebSession $session
        Write-Host "✅ Items endpoint working!" -ForegroundColor Green
        Write-Host "   Found $($itemsResponse.Count) items" -ForegroundColor White
        if ($itemsResponse.Count -gt 0) {
            Write-Host "   First item: $($itemsResponse[0].name)" -ForegroundColor White
        }
    } catch {
        Write-Host "❌ Items endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    
    # Step 5: Test low stock endpoint
    Write-Host "3. Testing /api/spareparts/low-stock..." -ForegroundColor Yellow
    try {
        $lowStockResponse = Invoke-RestMethod -Uri "http://localhost:8086/api/spareparts/low-stock" -WebSession $session
        Write-Host "✅ Low stock endpoint working!" -ForegroundColor Green
        Write-Host "   Found $($lowStockResponse.Count) low stock items" -ForegroundColor White
    } catch {
        Write-Host "❌ Low stock endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "🎉 API Testing Complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Access the dashboard at: http://localhost:8086" -ForegroundColor Cyan
    Write-Host "👤 Login with: admin/admin123" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
}
