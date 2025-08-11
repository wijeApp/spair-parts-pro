@echo off
echo ========================================
echo IMAGE PREVIEW TESTING SCRIPT
echo ========================================
echo.

echo 1. Starting Spring Boot application...
cd /d "e:\my-pro\spair-parts-pro\spairparts-UI-01\spairparts"

echo.
echo 2. Application starting... Please wait...
echo.
echo IMPORTANT TESTING STEPS:
echo ========================
echo.
echo After the app starts, test these URLs:
echo.
echo   1. Main App: http://localhost:8084/
echo   2. Debug Info: http://localhost:8084/api/debug/image-config
echo.
echo DEBUGGING CHECKLIST:
echo ====================
echo   [x] WebConfig.java created for static resources
echo   [x] SecurityConfig.java updated to allow /uploads/**
echo   [x] Enhanced error handling in HTML template
echo   [x] Debug logging added to FileUploadService
echo   [x] Debug endpoint created at /api/debug/image-config
echo.
echo TEST PROCEDURE:
echo ===============
echo   1. Login as admin
echo   2. Add a new item with image
echo   3. Check console for upload debug messages
echo   4. Verify image displays in card
echo   5. If image fails, check browser console for errors
echo   6. Visit debug endpoint for configuration info
echo.

start "Spring Boot App" cmd /k "mvn spring-boot:run"

echo.
echo Application launching in new window...
echo Check console output for any errors.
echo.
pause
