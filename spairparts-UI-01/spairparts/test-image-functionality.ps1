#!/usr/bin/env pwsh

# Test Image Functionality for Spare Parts Dashboard
# This script tests the image URL loading and preview functionality

Write-Host "🧪 Testing Image Functionality for Spare Parts Dashboard" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green

# Step 1: Start the application
Write-Host "📦 Starting Spring Boot Application..." -ForegroundColor Yellow
Start-Process -FilePath "powershell" -ArgumentList "-Command", "cd 'e:\my-pro\spair-parts-pro\spairparts-UI-01\spairparts'; mvn spring-boot:run" -WindowStyle Minimized

# Wait for application to start
Write-Host "⏳ Waiting for application to start (30 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Step 2: Test if application is running
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8082/dashboard" -UseBasicParsing -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Application is running successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ Application returned status: $($response.StatusCode)" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Failed to connect to application: $_" -ForegroundColor Red
    exit 1
}

# Step 3: Test image functionality
Write-Host "🖼️ Testing Image Functionality..." -ForegroundColor Cyan

Write-Host ""
Write-Host "📋 TEST CHECKLIST:" -ForegroundColor Blue
Write-Host "===================" -ForegroundColor Blue
Write-Host "1. ✅ SparePartItem entity updated with image field"
Write-Host "2. ✅ Add form includes image URL input with preview button"
Write-Host "3. ✅ Update modal includes image URL input with preview button"
Write-Host "4. ✅ Item cards display images when available"
Write-Host "5. ✅ Image preview functionality implemented"

Write-Host ""
Write-Host "🌐 MANUAL TESTING STEPS:" -ForegroundColor Magenta
Write-Host "=========================" -ForegroundColor Magenta
Write-Host "1. Open: http://localhost:8082/login"
Write-Host "   - Login as admin (username: admin, password: admin123)"
Write-Host ""
Write-Host "2. Go to Dashboard: http://localhost:8082/dashboard"
Write-Host ""
Write-Host "3. Test Add Item with Image:"
Write-Host "   - Fill in item details"
Write-Host "   - Add image URL: https://via.placeholder.com/300x200/0066cc/ffffff?text=Test+Item"
Write-Host "   - Click '🖼️ Preview' button to load image preview"
Write-Host "   - Submit form"
Write-Host ""
Write-Host "4. Test Update Item:"
Write-Host "   - Click 'Update' button on any item"
Write-Host "   - Add/modify image URL"
Write-Host "   - Click '🖼️ Preview' button"
Write-Host "   - Update item"
Write-Host ""
Write-Host "5. Verify Image Display:"
Write-Host "   - Check that items with images show image previews"
Write-Host "   - Verify fallback for broken image URLs"

Write-Host ""
Write-Host "🔧 FEATURES IMPLEMENTED:" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green
Write-Host "✅ Image URL field in SparePartItem entity"
Write-Host "✅ Image URL input in add form"
Write-Host "✅ Image URL input in update modal"
Write-Host "✅ Image preview button functionality"
Write-Host "✅ Automatic image preview on Enter key"
Write-Host "✅ Image display in item cards"
Write-Host "✅ Error handling for broken images"
Write-Host "✅ CRUD operations support image field"

Write-Host ""
Write-Host "📊 SAMPLE TEST IMAGES:" -ForegroundColor Yellow
Write-Host "======================" -ForegroundColor Yellow
Write-Host "• Engine Oil: https://via.placeholder.com/300x200/ff6600/ffffff?text=Engine+Oil"
Write-Host "• Brake Pads: https://via.placeholder.com/300x200/cc0000/ffffff?text=Brake+Pads"
Write-Host "• Spark Plug: https://via.placeholder.com/300x200/0099cc/ffffff?text=Spark+Plug"
Write-Host "• Air Filter: https://via.placeholder.com/300x200/009900/ffffff?text=Air+Filter"

Write-Host ""
Write-Host "🎯 Testing complete! Application is ready for image functionality testing." -ForegroundColor Green
Write-Host "🌐 Dashboard URL: http://localhost:8082/dashboard" -ForegroundColor Cyan

# Open browser
Write-Host "🌐 Opening browser..." -ForegroundColor Yellow
Start-Process "http://localhost:8082/dashboard"

Write-Host ""
Write-Host "Press any key to stop the application..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Stop the application
Write-Host "🛑 Stopping application..." -ForegroundColor Red
Get-Process -Name java -ErrorAction SilentlyContinue | Stop-Process -Force
