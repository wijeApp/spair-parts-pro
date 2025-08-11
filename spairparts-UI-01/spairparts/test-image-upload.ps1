#!/usr/bin/env pwsh

Write-Host "🚀 Testing Image Upload Functionality" -ForegroundColor Green
Write-Host "======================================"

# Start the application in background
Write-Host "Starting Spring Boot application..." -ForegroundColor Yellow
$app = Start-Process -FilePath "mvn" -ArgumentList "spring-boot:run" -WorkingDirectory "." -PassThru

# Wait for application to start
Write-Host "Waiting for application to start (30 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

try {
    # Test 1: Create a simple text file as an image for testing
    Write-Host "`n📝 Creating test image file..." -ForegroundColor Cyan
    $testImageContent = "This is a test image file content"
    $testImagePath = "test-image.txt"
    Set-Content -Path $testImagePath -Value $testImageContent
    
    # Test 2: Test basic item creation without image
    Write-Host "`n🧪 Test 1: Creating item without image..." -ForegroundColor Cyan
    $basicItemData = @{
        name = "Test Item No Image"
        description = "Test item created without image"
        price = 99.99
        quantity = 5
        currency = "USD"
    } | ConvertTo-Json

    $response1 = Invoke-RestMethod -Uri "http://localhost:8080/api/spareparts" -Method POST -Body $basicItemData -ContentType "application/json" -ErrorAction SilentlyContinue
    if ($response1) {
        Write-Host "✅ Basic item created successfully - ID: $($response1.id)" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to create basic item" -ForegroundColor Red
    }

    # Test 3: Test image upload endpoint exists
    Write-Host "`n🧪 Test 2: Testing image upload endpoint availability..." -ForegroundColor Cyan
    try {
        # Create multipart form data manually
        $boundary = [System.Guid]::NewGuid().ToString()
        
        $bodyTemplate = @"
--$boundary
Content-Disposition: form-data; name="name"

Test Item With Image
--$boundary
Content-Disposition: form-data; name="description"

Test item created with image upload
--$boundary
Content-Disposition: form-data; name="price"

149.99
--$boundary
Content-Disposition: form-data; name="quantity"

10
--$boundary
Content-Disposition: form-data; name="currency"

USD
--$boundary
Content-Disposition: form-data; name="image"; filename="test-image.txt"
Content-Type: text/plain

$testImageContent
--$boundary--
"@

        $response2 = Invoke-RestMethod -Uri "http://localhost:8080/api/spareparts/with-image" -Method POST -Body $bodyTemplate -ContentType "multipart/form-data; boundary=$boundary" -ErrorAction SilentlyContinue
        if ($response2) {
            Write-Host "✅ Item with image created successfully - ID: $($response2.id)" -ForegroundColor Green
            if ($response2.imagePath) {
                Write-Host "📷 Image path: $($response2.imagePath)" -ForegroundColor Green
            }
        } else {
            Write-Host "❌ Failed to create item with image" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Image upload endpoint error: $($_.Exception.Message)" -ForegroundColor Red
    }

    # Test 4: List all items to verify
    Write-Host "`n🧪 Test 3: Retrieving all items..." -ForegroundColor Cyan
    $allItems = Invoke-RestMethod -Uri "http://localhost:8080/api/spareparts" -Method GET -ErrorAction SilentlyContinue
    if ($allItems) {
        Write-Host "✅ Retrieved $($allItems.Count) items total" -ForegroundColor Green
        foreach ($item in $allItems) {
            $imageStatus = if ($item.imagePath) { "📷 Has Image: $($item.imagePath)" } else { "📷 No Image" }
            Write-Host "   • ID: $($item.id) | Name: $($item.name) | $imageStatus" -ForegroundColor White
        }
    } else {
        Write-Host "❌ Failed to retrieve items" -ForegroundColor Red
    }

    # Test 5: Check uploads directory
    Write-Host "`n🧪 Test 4: Checking uploads directory..." -ForegroundColor Cyan
    $uploadsDir = "uploads"
    if (Test-Path $uploadsDir) {
        $files = Get-ChildItem $uploadsDir -File
        Write-Host "✅ Uploads directory exists with $($files.Count) files" -ForegroundColor Green
        foreach ($file in $files) {
            Write-Host "   • $($file.Name) ($($file.Length) bytes)" -ForegroundColor White
        }
    } else {
        Write-Host "⚠️  Uploads directory does not exist yet" -ForegroundColor Yellow
    }

} catch {
    Write-Host "❌ Test error: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # Cleanup
    Write-Host "`n🧹 Cleaning up..." -ForegroundColor Yellow
    if (Test-Path $testImagePath) {
        Remove-Item $testImagePath -Force
        Write-Host "Removed test image file" -ForegroundColor Yellow
    }
    
    # Stop the application
    Write-Host "Stopping application..." -ForegroundColor Yellow
    if ($app -and !$app.HasExited) {
        $app.Kill()
        $app.WaitForExit(5000)
    }
}

Write-Host "`n🎯 Image Upload Functionality Test Complete!" -ForegroundColor Green
Write-Host "============================================"
