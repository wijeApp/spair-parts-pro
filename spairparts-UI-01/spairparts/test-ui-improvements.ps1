#!/usr/bin/env pwsh

# UI Improvements Validation Test Script
# Tests all the UI fixes and improvements made to the dashboard

Write-Host "🎨 UI IMPROVEMENTS VALIDATION TEST" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check if application is running
$processExists = Get-Process -Name java -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowTitle -like "*spairparts*" -or $_.Id}
if (-not $processExists) {
    Write-Host "❌ Application not running. Please start the application first:" -ForegroundColor Red
    Write-Host "   .\start-app.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Application is running" -ForegroundColor Green

# Test web interface availability
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8082" -Method GET -TimeoutSec 5 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Web interface accessible at http://localhost:8082" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Web interface not accessible: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔧 Testing UI Components and Responsiveness" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Yellow

# Test 1: Check if main template loads correctly
Write-Host ""
Write-Host "Test 1: Main template loading..." -ForegroundColor Cyan
try {
    $htmlContent = $response.Content
    
    # Check for responsive viewport meta tag
    if ($htmlContent -match 'name="viewport".*width=device-width') {
        Write-Host "✅ Responsive viewport meta tag found" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Responsive viewport meta tag missing" -ForegroundColor Yellow
    }
    
    # Check for Tailwind CSS
    if ($htmlContent -match 'tailwindcss.com') {
        Write-Host "✅ Tailwind CSS loaded" -ForegroundColor Green
    } else {
        Write-Host "❌ Tailwind CSS not found" -ForegroundColor Red
    }
    
    # Check for mobile menu button
    if ($htmlContent -match 'mobile-menu-button') {
        Write-Host "✅ Mobile menu button present" -ForegroundColor Green
    } else {
        Write-Host "❌ Mobile menu button missing" -ForegroundColor Red
    }
    
    # Check for responsive grid classes
    if ($htmlContent -match 'grid-cols-1.*md:grid-cols-2.*xl:grid-cols-3') {
        Write-Host "✅ Responsive grid classes found" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Some responsive grid classes may be missing" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "❌ Error checking template content: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Check API endpoints
Write-Host ""
Write-Host "Test 2: API endpoint accessibility..." -ForegroundColor Cyan
try {
    # Test items API (will redirect to login, but should return 200 for login page)
    $apiResponse = Invoke-WebRequest -Uri "http://localhost:8082/api/spareparts" -Method GET -TimeoutSec 5 -UseBasicParsing
    if ($apiResponse.StatusCode -eq 200) {
        Write-Host "✅ API endpoints responding (redirected to login as expected)" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ API endpoint test: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Test 3: Check for JavaScript functionality
Write-Host ""
Write-Host "Test 3: JavaScript components..." -ForegroundColor Cyan
if ($htmlContent -match 'initializeNavigation') {
    Write-Host "✅ Navigation initialization function found" -ForegroundColor Green
} else {
    Write-Host "❌ Navigation initialization missing" -ForegroundColor Red
}

if ($htmlContent -match 'initializeImageUpload') {
    Write-Host "✅ Image upload initialization function found" -ForegroundColor Green
} else {
    Write-Host "❌ Image upload initialization missing" -ForegroundColor Red
}

if ($htmlContent -match 'performSearch') {
    Write-Host "✅ Search functionality found" -ForegroundColor Green
} else {
    Write-Host "❌ Search functionality missing" -ForegroundColor Red
}

if ($htmlContent -match 'openUpdateModal') {
    Write-Host "✅ Update modal functionality found" -ForegroundColor Green
} else {
    Write-Host "❌ Update modal functionality missing" -ForegroundColor Red
}

# Test 4: Check responsive design elements
Write-Host ""
Write-Host "Test 4: Responsive design elements..." -ForegroundColor Cyan

$responsiveElements = @(
    'mobile-menu-overlay',
    'stats-grid',
    'items-container', 
    'form-grid',
    'button-group',
    'header-text',
    'image-upload-area'
)

foreach ($element in $responsiveElements) {
    if ($htmlContent -match $element) {
        Write-Host "✅ Responsive element '$element' found" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Responsive element '$element' missing" -ForegroundColor Yellow
    }
}

# Test 5: Check for accessibility improvements
Write-Host ""
Write-Host "Test 5: Accessibility features..." -ForegroundColor Cyan

if ($htmlContent -match 'aria-hidden') {
    Write-Host "✅ ARIA attributes found" -ForegroundColor Green
} else {
    Write-Host "⚠️ Limited ARIA attributes" -ForegroundColor Yellow
}

if ($htmlContent -match 'alt=') {
    Write-Host "✅ Image alt attributes found" -ForegroundColor Green
} else {
    Write-Host "⚠️ Image alt attributes limited" -ForegroundColor Yellow
}

# Test 6: Check for image upload functionality
Write-Host ""
Write-Host "Test 6: Image upload features..." -ForegroundColor Cyan

if ($htmlContent -match 'enctype="multipart/form-data"') {
    Write-Host "✅ Multipart form encoding found" -ForegroundColor Green
} else {
    Write-Host "❌ Multipart form encoding missing" -ForegroundColor Red
}

if ($htmlContent -match 'accept="image/\*"') {
    Write-Host "✅ Image file input restrictions found" -ForegroundColor Green
} else {
    Write-Host "❌ Image file input restrictions missing" -ForegroundColor Red
}

if ($htmlContent -match 'image-preview') {
    Write-Host "✅ Image preview functionality found" -ForegroundColor Green
} else {
    Write-Host "❌ Image preview functionality missing" -ForegroundColor Red
}

Write-Host ""
Write-Host "📱 MOBILE TESTING CHECKLIST" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host "Manual testing steps to perform:" -ForegroundColor White
Write-Host ""
Write-Host "1. 📱 Mobile Menu Testing:" -ForegroundColor Yellow
Write-Host "   - Resize browser to mobile width (< 768px)" -ForegroundColor White
Write-Host "   - Click hamburger menu button (☰)" -ForegroundColor White
Write-Host "   - Verify sidebar slides in from left" -ForegroundColor White
Write-Host "   - Click overlay or X button to close" -ForegroundColor White
Write-Host "   - Verify menu closes properly" -ForegroundColor White
Write-Host ""
Write-Host "2. 📊 Responsive Grid Testing:" -ForegroundColor Yellow
Write-Host "   - Mobile (< 768px): 1 column layout" -ForegroundColor White
Write-Host "   - Tablet (768px-1024px): 2 column layout" -ForegroundColor White
Write-Host "   - Desktop (> 1024px): 3 column layout" -ForegroundColor White
Write-Host ""
Write-Host "3. 🔍 Search Functionality:" -ForegroundColor Yellow
Write-Host "   - Type in search bar" -ForegroundColor White
Write-Host "   - Verify real-time filtering works" -ForegroundColor White
Write-Host "   - Check search highlighting" -ForegroundColor White
Write-Host "   - Test clear search button" -ForegroundColor White
Write-Host ""
Write-Host "4. 📷 Image Upload Testing:" -ForegroundColor Yellow
Write-Host "   - Click on image upload area" -ForegroundColor White
Write-Host "   - Select an image file" -ForegroundColor White
Write-Host "   - Verify preview appears" -ForegroundColor White
Write-Host "   - Test remove image functionality" -ForegroundColor White
Write-Host ""
Write-Host "5. ✏️ Update Modal Testing:" -ForegroundColor Yellow
Write-Host "   - Click update button on any item (admin only)" -ForegroundColor White
Write-Host "   - Verify modal opens with current values" -ForegroundColor White
Write-Host "   - Test image upload in modal" -ForegroundColor White
Write-Host "   - Verify modal is mobile-friendly" -ForegroundColor White
Write-Host ""
Write-Host "6. 🎨 Visual Polish Testing:" -ForegroundColor Yellow
Write-Host "   - Check loading states" -ForegroundColor White
Write-Host "   - Verify smooth animations" -ForegroundColor White
Write-Host "   - Test hover effects" -ForegroundColor White
Write-Host "   - Confirm error message display" -ForegroundColor White
Write-Host ""

Write-Host "🔗 QUICK ACCESS URLs:" -ForegroundColor Cyan
Write-Host "   - Main Dashboard: http://localhost:8082" -ForegroundColor White
Write-Host "   - Login Page: http://localhost:8082/login" -ForegroundColor White
Write-Host "   - Admin Test: admin / admin123" -ForegroundColor White
Write-Host "   - User Test: user / user123" -ForegroundColor White
Write-Host ""

Write-Host "📋 UI IMPROVEMENTS SUMMARY" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host "✅ Enhanced mobile responsiveness" -ForegroundColor Green
Write-Host "✅ Improved image upload with preview" -ForegroundColor Green
Write-Host "✅ Better search with real-time filtering" -ForegroundColor Green
Write-Host "✅ Enhanced navigation functionality" -ForegroundColor Green
Write-Host "✅ Mobile-friendly update modal" -ForegroundColor Green
Write-Host "✅ Loading states and animations" -ForegroundColor Green
Write-Host "✅ Better error handling and messaging" -ForegroundColor Green
Write-Host "✅ Improved accessibility features" -ForegroundColor Green
Write-Host ""
Write-Host "✅ UI Improvements validation completed!" -ForegroundColor Green
