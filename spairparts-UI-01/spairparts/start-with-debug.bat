@echo off
echo ======================================
echo Starting Spare Parts Application
echo ======================================
echo.
echo Configuration:
echo - Profile: dev
echo - Database: MySQL (localhost:3306/spareparts_db)
echo - Username: root
echo - Password: myRoot@123
echo.
echo Starting application...
echo.

java -jar target\spairparts-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev --logging.level.org.springframework.boot.autoconfigure.jdbc=DEBUG --logging.level.com.zaxxer.hikari=DEBUG

echo.
echo Application stopped.
pause
