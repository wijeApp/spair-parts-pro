# Manual Image Upload Test for Spare Parts Application

Write-Host "IMAGE UPLOAD TEST" -ForegroundColor Cyan
Write-Host "=================" -ForegroundColor Cyan
Write-Host ""

# Check if application is running
$javaProcesses = Get-Process -Name java -ErrorAction SilentlyContinue
if (-not $javaProcesses) {
    Write-Host "Application not running. Please start it first:" -ForegroundColor Red
    Write-Host "   .\start-app.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "Application is running (Java processes: $($javaProcesses.Count))" -ForegroundColor Green

# Test web interface
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8082" -Method GET -TimeoutSec 5
    Write-Host "Web interface accessible at http://localhost:8082" -ForegroundColor Green
} catch {
    Write-Host "Web interface not accessible: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Create test image
Write-Host ""
Write-Host "Creating test image..." -ForegroundColor Yellow
$testImagePath = "test-sample-upload.png"
try {
    # Create a simple PNG image
    $pngBytes = [byte[]](0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x64, 0x00, 0x00, 0x00, 0x64, 0x08, 0x02, 0x00, 0x00, 0x00, 0xFF, 0x80, 0x02, 0x03, 0x00, 0x00, 0x00, 0x20, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0xED, 0xC1, 0x01, 0x01, 0x00, 0x00, 0x00, 0x80, 0x90, 0xFE, 0xAF, 0xEE, 0x08, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82)
    [System.IO.File]::WriteAllBytes($testImagePath, $pngBytes)
    $fileSize = (Get-Item $testImagePath).Length
    Write-Host "Test image created: $testImagePath ($fileSize bytes)" -ForegroundColor Green
} catch {
    Write-Host "Failed to create test image: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Check uploads directory
Write-Host ""
Write-Host "Checking uploads directory..." -ForegroundColor Yellow
if (Test-Path "uploads") {
    $existingFiles = Get-ChildItem "uploads" -File
    Write-Host "Uploads directory exists with $($existingFiles.Count) files" -ForegroundColor Green
    if ($existingFiles.Count -gt 0) {
        Write-Host "Existing files:" -ForegroundColor Gray
        $existingFiles | ForEach-Object { Write-Host "   - $($_.Name)" -ForegroundColor Gray }
    }
} else {
    Write-Host "Uploads directory will be created automatically" -ForegroundColor Yellow
}

# Manual testing instructions
Write-Host ""
Write-Host "MANUAL TESTING INSTRUCTIONS" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Open your web browser and navigate to:" -ForegroundColor White
Write-Host "   http://localhost:8082" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Login with admin credentials:" -ForegroundColor White
Write-Host "   Username: admin" -ForegroundColor Yellow
Write-Host "   Password: admin123" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Test adding a new item with image:" -ForegroundColor White
Write-Host "   a) Click the 'Add New Item' button" -ForegroundColor Gray
Write-Host "   b) Fill in the item details:" -ForegroundColor Gray
Write-Host "      - Name: Test Item with Image" -ForegroundColor Gray
Write-Host "      - Description: Testing image upload functionality" -ForegroundColor Gray
Write-Host "      - Price: 29.99" -ForegroundColor Gray
Write-Host "      - Quantity: 1" -ForegroundColor Gray
Write-Host "   c) Click on the image upload area" -ForegroundColor Gray
Write-Host "   d) Select the test image: $testImagePath" -ForegroundColor Gray
Write-Host "   e) Verify the image preview appears" -ForegroundColor Gray
Write-Host "   f) Click 'Add Item' to submit" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Verify the item appears with the image" -ForegroundColor White
Write-Host ""
Write-Host "5. Test updating an existing item with image:" -ForegroundColor White
Write-Host "   a) Click the 'Edit' button on any item" -ForegroundColor Gray
Write-Host "   b) Upload a new image using the update form" -ForegroundColor Gray
Write-Host "   c) Submit the update" -ForegroundColor Gray
Write-Host ""

# API endpoints information
Write-Host "API ENDPOINTS" -ForegroundColor Cyan
Write-Host "=============" -ForegroundColor Cyan
Write-Host "- GET  /api/spareparts                  - List all items" -ForegroundColor White
Write-Host "- POST /api/spareparts/with-image       - Add item with image" -ForegroundColor White
Write-Host "- PUT  /api/spareparts/{id}/with-image  - Update item with image" -ForegroundColor White
Write-Host "- GET  /uploads/{filename}              - View uploaded images" -ForegroundColor White
Write-Host ""

# File structure verification
Write-Host "FILE STRUCTURE VERIFICATION" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
$requiredFiles = @(
    "src/main/java/com/tas/spairparts/SparePartItem.java",
    "src/main/java/com/tas/spairparts/FileUploadService.java", 
    "src/main/java/com/tas/spairparts/FileUploadConfig.java",
    "src/main/java/com/tas/spairparts/SparePartsController.java",
    "src/main/resources/application.properties"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "FOUND: $file" -ForegroundColor Green
    } else {
        Write-Host "MISSING: $file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "EXPECTED RESULTS" -ForegroundColor Cyan
Write-Host "================" -ForegroundColor Cyan
Write-Host "- Items can be added with images via web form" -ForegroundColor Green
Write-Host "- Items can be updated with new images" -ForegroundColor Green
Write-Host "- Images are stored in ./uploads/ directory" -ForegroundColor Green
Write-Host "- Images are served via /uploads/{filename} URL" -ForegroundColor Green
Write-Host "- Image paths are saved in spare_part_items.image_path column" -ForegroundColor Green
Write-Host "- Image preview works in web interface" -ForegroundColor Green
Write-Host "- File validation works (size and type)" -ForegroundColor Green
Write-Host ""
Write-Host "Image upload functionality is ready for testing!" -ForegroundColor Green
