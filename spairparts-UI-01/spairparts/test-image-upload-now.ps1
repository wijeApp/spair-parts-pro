# 🧪 ONE-STEP IMAGE UPLOAD TEST

Write-Host ""
Write-Host "🖼️ TESTING IMAGE UPLOAD FUNCTIONALITY" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Test 1: Verify application is running
Write-Host ""
Write-Host "1. Checking application status..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8082" -Method GET -TimeoutSec 5
    Write-Host "   ✅ Application is running at http://localhost:8082" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Application not accessible. Run: .\start-app.ps1" -ForegroundColor Red
    exit 1
}

# Test 2: Create sample image
Write-Host ""
Write-Host "2. Creating test image for upload..." -ForegroundColor Yellow
$testImage = "sample-part-image.png"
if (Test-Path $testImage) {
    Write-Host "   ✅ Test image already exists: $testImage" -ForegroundColor Green
} else {
    try {
        # Create a small valid PNG image (1x1 transparent pixel)
        $pngData = [byte[]](0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A,0x00,0x00,0x00,0x0D,0x49,0x48,0x44,0x52,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x01,0x08,0x06,0x00,0x00,0x00,0x1F,0x15,0xC4,0x89,0x00,0x00,0x00,0x0D,0x49,0x44,0x41,0x54,0x78,0x9C,0x62,0x00,0x02,0x00,0x00,0x05,0x00,0x01,0xE2,0x26,0x05,0x9B,0x00,0x00,0x00,0x00,0x49,0x45,0x4E,0x44,0xAE,0x42,0x60,0x82)
        [System.IO.File]::WriteAllBytes($testImage, $pngData)
        Write-Host "   ✅ Test image created: $testImage" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ Failed to create test image" -ForegroundColor Red
        exit 1
    }
}

# Test 3: Check uploads directory
Write-Host ""
Write-Host "3. Checking uploads directory..." -ForegroundColor Yellow
if (Test-Path "uploads") {
    $uploadCount = (Get-ChildItem "uploads" -File).Count
    Write-Host "   ✅ Uploads directory exists with $uploadCount files" -ForegroundColor Green
} else {
    Write-Host "   ℹ️ Uploads directory will be created on first upload" -ForegroundColor Cyan
}

# Test 4: Display manual test instructions
Write-Host ""
Write-Host "🎯 MANUAL TEST STEPS" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NOW FOLLOW THESE STEPS TO TEST IMAGE UPLOAD:" -ForegroundColor White
Write-Host ""
Write-Host "Step 1: Open your web browser" -ForegroundColor Yellow
Write-Host "Step 2: Go to http://localhost:8082" -ForegroundColor Yellow  
Write-Host "Step 3: Login with:" -ForegroundColor Yellow
Write-Host "        Username: admin" -ForegroundColor White
Write-Host "        Password: admin123" -ForegroundColor White
Write-Host ""
Write-Host "Step 4: Click the '➕ Add New Item' button" -ForegroundColor Yellow
Write-Host "Step 5: Fill in the form:" -ForegroundColor Yellow
Write-Host "        Name: Test Spare Part with Image" -ForegroundColor White
Write-Host "        Description: Testing image upload functionality" -ForegroundColor White
Write-Host "        Price: 25.99" -ForegroundColor White
Write-Host "        Quantity: 1" -ForegroundColor White
Write-Host ""
Write-Host "Step 6: Click on the image upload area" -ForegroundColor Yellow
Write-Host "Step 7: Select the file: $testImage" -ForegroundColor White
Write-Host "Step 8: Verify image preview appears" -ForegroundColor Yellow
Write-Host "Step 9: Click 'Add Item' to submit" -ForegroundColor Yellow
Write-Host ""
Write-Host "✅ EXPECTED RESULTS:" -ForegroundColor Green
Write-Host "- Item appears in the list with the uploaded image" -ForegroundColor White
Write-Host "- Image is clickable and displays properly" -ForegroundColor White
Write-Host "- File is saved in uploads/ directory" -ForegroundColor White
Write-Host ""
Write-Host "🔄 TO TEST UPDATE:" -ForegroundColor Cyan
Write-Host "- Click '✏️ Edit' on any existing item" -ForegroundColor White
Write-Host "- Upload a new image in the update form" -ForegroundColor White
Write-Host "- Verify the image updates successfully" -ForegroundColor White
Write-Host ""

# Show current directory files for reference
Write-Host "📁 FILES IN CURRENT DIRECTORY:" -ForegroundColor Gray
Write-Host "------------------------------" -ForegroundColor Gray
Get-ChildItem -Name "*.png", "*.jpg", "*.jpeg" | ForEach-Object { 
    Write-Host "   $_ (ready for upload)" -ForegroundColor Gray 
}

Write-Host ""
Write-Host "🎉 IMAGE UPLOAD TESTING READY!" -ForegroundColor Green
Write-Host "Follow the manual steps above to verify functionality." -ForegroundColor White
