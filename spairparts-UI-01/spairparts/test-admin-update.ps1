# Admin Update Functionality Test Script
# This PowerShell script helps verify the admin update functionality

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "✏️ ADMIN UPDATE FUNCTIONALITY TEST" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Function to check if application is running
function Test-ApplicationRunning {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8082/login" -Method GET -TimeoutSec 5 -UseBasicParsing
        return $response.StatusCode -eq 200
    }
    catch {
        return $false
    }
}

# Function to test admin login
function Test-AdminLogin {
    Write-Host "🔐 Testing Admin Login..." -ForegroundColor Yellow
    
    try {
        # Create a web session
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        
        # Get login page to retrieve any CSRF tokens
        $loginPage = Invoke-WebRequest -Uri "http://localhost:8082/login" -Method GET -WebSession $session -UseBasicParsing
        
        # Prepare login data
        $loginData = @{
            username = 'Admin'
            password = 'Admin123'
        }
        
        # Add CSRF token if present
        if ($loginPage.Content -match 'name="_csrf"[^>]*value="([^"]*)"') {
            $loginData['_csrf'] = $matches[1]
            Write-Host "   CSRF token found and added" -ForegroundColor Green
        }
        
        # Perform login
        $loginResponse = Invoke-WebRequest -Uri "http://localhost:8082/login" -Method POST -Body $loginData -WebSession $session -UseBasicParsing
        
        if ($loginResponse.StatusCode -eq 200 -and $loginResponse.Headers.Location -like "*dashboard*") {
            Write-Host "   ✅ Admin login successful" -ForegroundColor Green
            return $session
        }
        else {
            Write-Host "   ❌ Admin login failed" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Host "   ❌ Login error: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Function to test API endpoints
function Test-UpdateAPI {
    param($session)
    
    Write-Host "🔄 Testing Update API Security..." -ForegroundColor Yellow
    
    try {
        # Test GET all items
        $itemsResponse = Invoke-WebRequest -Uri "http://localhost:8082/api/spareparts" -Method GET -WebSession $session -UseBasicParsing
        $items = $itemsResponse.Content | ConvertFrom-Json
        
        if ($items.Count -gt 0) {
            Write-Host "   📦 Found $($items.Count) items in database" -ForegroundColor Green
            
            # Test update with admin session
            $testItem = $items[0]
            $updateData = @{
                name = "$($testItem.name) - Updated by PowerShell Test"
                description = "$($testItem.description) - Modified for testing"
                price = $testItem.price + 100
                quantity = $testItem.quantity + 1
                currency = $testItem.currency
            } | ConvertTo-Json
            
            Write-Host "   🔄 Testing update for item ID: $($testItem.id)" -ForegroundColor Cyan
            
            $updateResponse = Invoke-WebRequest -Uri "http://localhost:8082/api/spareparts/$($testItem.id)" -Method PUT -Body $updateData -ContentType "application/json" -WebSession $session -UseBasicParsing
            
            if ($updateResponse.StatusCode -eq 200) {
                Write-Host "   ✅ Update API works correctly for admin" -ForegroundColor Green
                
                # Verify the update
                $updatedItemResponse = Invoke-WebRequest -Uri "http://localhost:8082/api/spareparts/$($testItem.id)" -Method GET -WebSession $session -UseBasicParsing
                $updatedItem = $updatedItemResponse.Content | ConvertFrom-Json
                
                Write-Host "   📋 Updated item details:" -ForegroundColor Cyan
                Write-Host "      Name: $($updatedItem.name)" -ForegroundColor White
                Write-Host "      Price: $($updatedItem.price)" -ForegroundColor White
                Write-Host "      Quantity: $($updatedItem.quantity)" -ForegroundColor White
                
                return $true
            }
            else {
                Write-Host "   ❌ Update API failed: $($updateResponse.StatusCode)" -ForegroundColor Red
                return $false
            }
        }
        else {
            Write-Host "   ⚠️ No items found in database" -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "   ❌ API test error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to test unauthorized access
function Test-UnauthorizedUpdate {
    Write-Host "🔒 Testing Unauthorized Update Access..." -ForegroundColor Yellow
    
    try {
        # Create new session without admin login
        $unauthorizedSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        
        # Try to update an item without authentication
        $testData = @{
            name = "Unauthorized Update Attempt"
            description = "This should fail"
            price = 999.99
            quantity = 1
            currency = "USD"
        } | ConvertTo-Json
        
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8082/api/spareparts/1" -Method PUT -Body $testData -ContentType "application/json" -WebSession $unauthorizedSession -UseBasicParsing
            Write-Host "   ❌ Security vulnerability: Unauthorized update succeeded! Status: $($response.StatusCode)" -ForegroundColor Red
            return $false
        }
        catch {
            if ($_.Exception.Response.StatusCode -eq 401 -or $_.Exception.Response.StatusCode -eq 403) {
                Write-Host "   ✅ Unauthorized access properly blocked" -ForegroundColor Green
                return $true
            }
            else {
                Write-Host "   ⚠️ Unexpected error: $($_.Exception.Message)" -ForegroundColor Yellow
                return $false
            }
        }
    }
    catch {
        Write-Host "   ❌ Unauthorized test error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to open browser for manual testing
function Open-ManualTest {
    Write-Host "🌐 Opening browser for manual testing..." -ForegroundColor Yellow
    
    # Open login page
    Start-Process "http://localhost:8082/login"
    
    Write-Host "   📋 Manual Testing Instructions:" -ForegroundColor Cyan
    Write-Host "   1. Login with Admin/Admin123" -ForegroundColor White
    Write-Host "   2. Look for ✏️ Update buttons on item cards" -ForegroundColor White
    Write-Host "   3. Click an Update button to test modal" -ForegroundColor White
    Write-Host "   4. Modify item details and submit" -ForegroundColor White
    Write-Host "   5. Verify changes are saved" -ForegroundColor White
    Write-Host "   6. Test with regular user (user/user123)" -ForegroundColor White
    Write-Host "   7. Confirm Update buttons are not visible" -ForegroundColor White
}

# Main execution
Write-Host ""
Write-Host "🚀 Starting Admin Update Functionality Tests..." -ForegroundColor Green
Write-Host ""

# Check if application is running
Write-Host "🔍 Checking if application is running..." -ForegroundColor Yellow
if (Test-ApplicationRunning) {
    Write-Host "   ✅ Application is running on http://localhost:8082" -ForegroundColor Green
}
else {
    Write-Host "   ❌ Application is not running!" -ForegroundColor Red
    Write-Host "   Please start the application with: mvnw.cmd spring-boot:run" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Test admin login
$adminSession = Test-AdminLogin
if ($null -eq $adminSession) {
    Write-Host "❌ Cannot proceed without admin session" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Test update API
$apiTest = Test-UpdateAPI -session $adminSession
Write-Host ""

# Test unauthorized access
$securityTest = Test-UnauthorizedUpdate
Write-Host ""

# Summary
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "📊 TEST SUMMARY" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Admin Login:           $(if ($adminSession) { '✅ PASS' } else { '❌ FAIL' })" -ForegroundColor $(if ($adminSession) { 'Green' } else { 'Red' })
Write-Host "Update API:            $(if ($apiTest) { '✅ PASS' } else { '❌ FAIL' })" -ForegroundColor $(if ($apiTest) { 'Green' } else { 'Red' })
Write-Host "Security Test:         $(if ($securityTest) { '✅ PASS' } else { '❌ FAIL' })" -ForegroundColor $(if ($securityTest) { 'Green' } else { 'Red' })
Write-Host ""

$allTestsPassed = $adminSession -and $apiTest -and $securityTest

if ($allTestsPassed) {
    Write-Host "🎉 All automated tests PASSED!" -ForegroundColor Green
    Write-Host "Admin update functionality is working correctly." -ForegroundColor Green
}
else {
    Write-Host "⚠️ Some tests FAILED!" -ForegroundColor Yellow
    Write-Host "Please check the implementation and try again." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Would you like to open the browser for manual testing? (y/n): " -ForegroundColor Cyan -NoNewline
$userChoice = Read-Host

if ($userChoice -eq 'y' -or $userChoice -eq 'Y') {
    Open-ManualTest
}

Write-Host ""
Write-Host "Test completed!" -ForegroundColor Green
Read-Host "Press Enter to exit"
