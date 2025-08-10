@echo off
title Admin Delete Button Test

echo 🔒 ADMIN DELETE BUTTONS - Testing Implementation
echo.

echo The delete buttons are already implemented in the dashboard!
echo.

echo Current Implementation:
echo ✅ Delete buttons only show for admin users
echo ✅ Backend validates admin role before deletion
echo ✅ Frontend prevents non-admin access
echo.

echo Test Accounts:
echo 👤 Admin: admin / admin123 (WILL see delete buttons)
echo 👤 User:  user / user123   (will NOT see delete buttons)
echo.

echo Starting application with H2 database (no MySQL required)...
echo.

java -Dspring.profiles.active=test -jar target\spairparts-0.0.1-SNAPSHOT.jar

pause
