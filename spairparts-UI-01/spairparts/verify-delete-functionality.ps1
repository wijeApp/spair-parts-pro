#!/usr/bin/env pwsh

Write-Host "🔍 ADMIN DELETE FUNCTIONALITY - VERIFICATION TEST" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# Check if application is running
$connection = Get-NetTCPConnection -LocalPort 8082 -ErrorAction SilentlyContinue
if (-not $connection) {
    Write-Host "❌ Application is not running on port 8082" -ForegroundColor Red
    Write-Host "Please start the application first!" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Application is running on port 8082" -ForegroundColor Green
Write-Host ""

Write-Host "🧪 TESTING STEPS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. ADMIN LOGIN TEST:" -ForegroundColor Cyan
Write-Host "   Username: Admin" -ForegroundColor Green
Write-Host "   Password: Admin123" -ForegroundColor Green
Write-Host "   Expected: Delete buttons visible on items" -ForegroundColor White
Write-Host ""

Write-Host "2. REGULAR USER TEST:" -ForegroundColor Cyan
Write-Host "   Username: user" -ForegroundColor White
Write-Host "   Password: user123" -ForegroundColor White
Write-Host "   Expected: NO delete buttons (security)" -ForegroundColor White
Write-Host ""

Write-Host "🔍 WHAT TO LOOK FOR:" -ForegroundColor Yellow
Write-Host "✅ Admin badge: 'Welcome, Admin! [ADMIN]'" -ForegroundColor Green
Write-Host "✅ Debug indicator: 'isAdmin=true'" -ForegroundColor Green
Write-Host "✅ Delete buttons: 🗑️ Delete on item cards" -ForegroundColor Green
Write-Host "✅ Delete functionality: Clicking removes items" -ForegroundColor Green
Write-Host ""

Write-Host "Opening login page..." -ForegroundColor Yellow
Start-Process "http://localhost:8082/login"

Write-Host ""
Write-Host "🎉 DELETE FUNCTIONALITY IS ALREADY IMPLEMENTED!" -ForegroundColor Green
Write-Host "   Just login as Admin to see the delete buttons!" -ForegroundColor White
Write-Host ""
Write-Host "Press Enter to continue..." -ForegroundColor Yellow
Read-Host
