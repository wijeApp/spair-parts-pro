# PowerShell script to start Spring Boot application and test admin delete
Write-Host "🚀 Starting Spare Parts Application..." -ForegroundColor Green
Write-Host ""

# Check if Maven is available
try {
    mvn --version | Out-Null
    Write-Host "✅ Maven found" -ForegroundColor Green
} catch {
    Write-Host "❌ Maven not found. Please install Maven or use mvnw.cmd" -ForegroundColor Red
    exit 1
}

Write-Host "Starting Spring Boot application..."
Write-Host "This will start the server on http://localhost:8082" -ForegroundColor Cyan
Write-Host ""

Write-Host "Test Accounts for Admin Delete Testing:" -ForegroundColor Yellow
Write-Host "👤 Admin: username=admin, password=admin123 (CAN delete items)" -ForegroundColor Green
Write-Host "👤 User:  username=user,  password=user123  (CANNOT delete items)" -ForegroundColor Red
Write-Host ""

Write-Host "Expected Results:" -ForegroundColor Yellow
Write-Host "✅ Admin login: Will see red 🗑️ Delete buttons on item cards"
Write-Host "❌ User login:  Will NOT see any delete buttons"
Write-Host ""

# Start the application
Write-Host "Starting mvn spring-boot:run..." -ForegroundColor Cyan
mvn spring-boot:run
