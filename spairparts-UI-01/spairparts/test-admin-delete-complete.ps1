#!/usr/bin/env pwsh

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "   ADMIN DELETE FUNCTIONALITY - QUICK TEST" -ForegroundColor Yellow
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Checking if application is running on port 8082..." -ForegroundColor Yellow
$connection = Get-NetTCPConnection -LocalPort 8082 -ErrorAction SilentlyContinue

if (-not $connection) {
    Write-Host ""
    Write-Host "❌ Application is not running on port 8082" -ForegroundColor Red
    Write-Host "Please start the application first:" -ForegroundColor Yellow
    Write-Host "   mvn spring-boot:run" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "✅ Application is running!" -ForegroundColor Green
Write-Host ""
Write-Host "🧪 TESTING INSTRUCTIONS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. LOGIN AS ADMIN:" -ForegroundColor Cyan
Write-Host "   URL: http://localhost:8082/login" -ForegroundColor White
Write-Host "   Username: Admin" -ForegroundColor Green
Write-Host "   Password: Admin123" -ForegroundColor Green
Write-Host ""
Write-Host "2. VERIFY ADMIN ACCESS:" -ForegroundColor Cyan
Write-Host "   - Check for 'ADMIN' badge in welcome message" -ForegroundColor White
Write-Host "   - Look for 🗑️ Delete buttons on item cards" -ForegroundColor White
Write-Host "   - Open browser console (F12) and check for: isAdmin: true" -ForegroundColor White
Write-Host ""
Write-Host "3. TEST DELETE FUNCTIONALITY:" -ForegroundColor Cyan
Write-Host "   - Click any 🗑️ Delete button" -ForegroundColor White
Write-Host "   - Confirm deletion in dialog" -ForegroundColor White
Write-Host "   - Item should be removed from the list" -ForegroundColor White
Write-Host ""
Write-Host "4. DEBUG INFO:" -ForegroundColor Cyan
Write-Host "   URL: http://localhost:8082/debug/users" -ForegroundColor White
Write-Host ""

Write-Host "Opening login page..." -ForegroundColor Yellow
Start-Process "http://localhost:8082/login"

Write-Host ""
Write-Host "Opening debug page..." -ForegroundColor Yellow
Start-Process "http://localhost:8082/debug/users"

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "   TEST COMPLETE - Check browser windows" -ForegroundColor Yellow
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to continue"
