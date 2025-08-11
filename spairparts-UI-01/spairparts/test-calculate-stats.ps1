# Test script for calculateInitialStats fix
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Testing calculateInitialStats Fix" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "This script will:" -ForegroundColor Yellow
Write-Host "1. Start the Spring Boot application" -ForegroundColor Green
Write-Host "2. Open browser with developer console" -ForegroundColor Green
Write-Host "3. Check if statistics are calculated correctly" -ForegroundColor Green
Write-Host ""

Write-Host "Starting the application..." -ForegroundColor Yellow
$process = Start-Process -FilePath "mvn" -ArgumentList "spring-boot:run", "-Dspring-boot.run.profiles=dev" -PassThru -NoNewWindow

Write-Host ""
Write-Host "Waiting for application to start (15 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

Write-Host ""
Write-Host "Opening browser with testing instructions..." -ForegroundColor Yellow
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TESTING INSTRUCTIONS:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Open Developer Console (F12)" -ForegroundColor Green
Write-Host "2. Look for these console messages:" -ForegroundColor Green
Write-Host "   - '=== DEBUG: Analyzing item structure ==='" -ForegroundColor White
Write-Host "   - 'Final calculated statistics:'" -ForegroundColor White
Write-Host "   - Should show correct totalItems count" -ForegroundColor White
Write-Host ""

Write-Host "3. Check the dashboard cards:" -ForegroundColor Green
Write-Host "   - Total Items should show correct count" -ForegroundColor White
Write-Host "   - Total Value should be calculated" -ForegroundColor White
Write-Host "   - Low Stock Items should be counted" -ForegroundColor White
Write-Host "   - Average Price should be calculated" -ForegroundColor White
Write-Host ""

Write-Host "4. Test search functionality:" -ForegroundColor Green
Write-Host "   - Search for an item name" -ForegroundColor White
Write-Host "   - Total Items should update to filtered count" -ForegroundColor White
Write-Host "   - Clear search - count should restore" -ForegroundColor White
Write-Host ""

Write-Host "5. If you see 'No items found with primary method':" -ForegroundColor Green
Write-Host "   - Check if alternative method worked" -ForegroundColor White
Write-Host "   - Look for 'Alternative method found: X items'" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan

# Open browser
Start-Process "http://localhost:8080/spareparts"

Write-Host ""
Write-Host "Press any key to stop the application..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host ""
Write-Host "Stopping application..." -ForegroundColor Yellow

# Stop the Maven process and any Java processes
try {
    if ($process -and !$process.HasExited) {
        $process.Kill()
    }
    Get-Process -Name "java", "javaw" -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "Application stopped successfully." -ForegroundColor Green
} catch {
    Write-Host "Note: Some processes may still be running." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Test completed." -ForegroundColor Green
Read-Host "Press Enter to exit"
