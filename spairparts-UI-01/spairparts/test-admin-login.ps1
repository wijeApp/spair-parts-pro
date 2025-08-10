#!/usr/bin/env pwsh

# Test Admin Login Script
Write-Host "🔍 Testing Admin Login..." -ForegroundColor Yellow

# Check if app is running
$port = 8082
$connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
if (-not $connection) {
    Write-Host "❌ Application is not running on port $port" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Application is running on port $port" -ForegroundColor Green

# Test endpoints
$baseUrl = "http://localhost:$port"

Write-Host "`n🔐 Testing authentication endpoints..." -ForegroundColor Yellow
Write-Host "📍 Login page: $baseUrl/login" -ForegroundColor Cyan
Write-Host "📍 Debug users: $baseUrl/debug/users" -ForegroundColor Cyan
Write-Host "📍 Main dashboard: $baseUrl/" -ForegroundColor Cyan

Write-Host "`n🧪 Expected users in database:" -ForegroundColor Yellow
Write-Host "  - admin (role: ADMIN, password: admin123)" -ForegroundColor White
Write-Host "  - Admin (role: ADMIN, password: Admin123)" -ForegroundColor Green
Write-Host "  - user (role: USER, password: user123)" -ForegroundColor White

Write-Host "`n📝 To test admin delete functionality:" -ForegroundColor Yellow
Write-Host "  1. Go to: $baseUrl/login" -ForegroundColor White
Write-Host "  2. Login with: Username=Admin, Password=Admin123" -ForegroundColor Green
Write-Host "  3. Check debug info shows: isAdmin=true" -ForegroundColor White
Write-Host "  4. Delete buttons should be visible on item cards" -ForegroundColor White

Write-Host "`n🔍 Opening browser for testing..." -ForegroundColor Yellow
Start-Process "$baseUrl/login"
