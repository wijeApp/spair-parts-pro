@echo off
echo === STARTING ENHANCED STATISTICS DASHBOARD ===
echo.
echo Testing the enhanced statistics calculation...
echo Dashboard will be available at: http://localhost:8080/spareparts-responsive
echo Statistics API will be available at: http://localhost:8080/api/spareparts/statistics
echo.
echo Starting application...
mvn spring-boot:run -Dspring-boot.run.profiles=dev
