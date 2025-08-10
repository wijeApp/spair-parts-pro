@echo off
echo 🚀 Starting Spare Parts Application...
echo.

echo Test Accounts for Admin Delete Testing:
echo 👤 Admin: username=admin, password=admin123 (CAN delete items)
echo 👤 User:  username=user,  password=user123  (CANNOT delete items)
echo.

echo Expected Results:
echo ✅ Admin login: Will see red Delete buttons on item cards
echo ❌ User login:  Will NOT see any delete buttons
echo.

echo Starting Spring Boot application on http://localhost:8082
echo.

mvn spring-boot:run

pause
