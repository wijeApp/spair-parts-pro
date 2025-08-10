#!/usr/bin/env pwsh
# PowerShell script to start the Thymeleaf responsive dashboard

Write-Host "🚀 Starting Spare Parts Dashboard with Responsive Thymeleaf..." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan

# Navigate to project directory
$projectPath = "e:\my-pro\spair-parts-pro\spairparts-UI-01\spairparts"
Set-Location $projectPath

# Check if Maven is available
if (!(Get-Command mvn -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Maven not found in PATH. Please install Maven." -ForegroundColor Red
    exit 1
}

# Display project info
Write-Host "📁 Project Directory: $projectPath" -ForegroundColor Yellow
Write-Host "🔧 Building and starting application..." -ForegroundColor Yellow

# Clean and compile first
Write-Host "📦 Cleaning and compiling..." -ForegroundColor Blue
mvn clean compile

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Application will start on: http://localhost:8080" -ForegroundColor Cyan
    Write-Host "📱 Responsive Features:" -ForegroundColor Yellow
    Write-Host "   • Mobile-first design" -ForegroundColor White
    Write-Host "   • Tailwind CSS responsive grid" -ForegroundColor White
    Write-Host "   • Touch-friendly interface" -ForegroundColor White
    Write-Host "   • Adaptive navigation" -ForegroundColor White
    Write-Host ""
    Write-Host "👤 Login Credentials:" -ForegroundColor Yellow
    Write-Host "   Regular User: user / user123" -ForegroundColor White
    Write-Host "   Admin User:   admin / admin123" -ForegroundColor White
    Write-Host ""
    Write-Host "🧪 Testing Features:" -ForegroundColor Yellow
    Write-Host "   • Add new spare parts" -ForegroundColor White
    Write-Host "   • Server-side form validation" -ForegroundColor White
    Write-Host "   • Admin edit/delete functions" -ForegroundColor White
    Write-Host "   • Responsive design (resize browser)" -ForegroundColor White
    Write-Host ""
    Write-Host "Press Ctrl+C to stop the application" -ForegroundColor Gray
    Write-Host "============================================================" -ForegroundColor Cyan
    
    # Start the Spring Boot application
    mvn spring-boot:run
} else {
    Write-Host "❌ Build failed. Please check the errors above." -ForegroundColor Red
    Write-Host "💡 Try running: mvn clean install" -ForegroundColor Yellow
    exit 1
}