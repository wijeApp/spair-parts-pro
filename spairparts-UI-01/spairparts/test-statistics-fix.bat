@echo off
echo ===================================
echo Testing Statistics Fix for Spare Parts Dashboard
echo ===================================
echo.

echo 1. Testing Spring Boot Application Status...
curl -s -o NUL -w "HTTP Status: %%{http_code}\n" http://localhost:8080/
echo.

echo 2. Testing API Endpoint (/api/spareparts)...
curl -s -w "HTTP Status: %%{http_code}\n" http://localhost:8080/api/spareparts
echo.

echo 3. Testing Responsive Dashboard Page...
curl -s -o NUL -w "HTTP Status: %%{http_code}\n" http://localhost:8080/spareparts-responsive
echo.

echo 4. Testing Authentication Status...
curl -s -o NUL -w "HTTP Status: %%{http_code}\n" http://localhost:8080/login
echo.

echo ===================================
echo Statistics Fix Implementation Summary:
echo ===================================
echo.
echo ✅ Added fetchItems() function to retrieve data from /api/spareparts
echo ✅ Added updateStats() function to calculate and display statistics
echo ✅ Added loadDashboard() function to refresh data
echo ✅ Added calculateInitialStats() function for server-side data
echo ✅ Added automatic refresh every 30 seconds
echo ✅ Enhanced database status indicators
echo ✅ Added comprehensive console logging for debugging
echo.
echo The dashboard should now show:
echo - Total Items: Count from database
echo - Total Value: Sum of (price × quantity) for all items
echo - Low Stock Items: Items with quantity less than 10
echo - Average Price: Total value ÷ total quantity
echo.
echo ===================================
echo Next Steps:
echo ===================================
echo 1. Open browser: http://localhost:8080/spareparts-responsive
echo 2. Check browser console (F12) for debug logs
echo 3. Verify statistics show actual numbers instead of 0
echo 4. Test with admin user (admin/admin123) to see full functionality
echo.

pause
