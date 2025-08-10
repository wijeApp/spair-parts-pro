@echo off
echo Testing Maven Compilation with Java 17
cd /d "e:\my-pro\spair-parts-pro\spairparts-UI-01\spairparts"
call .\mvnw clean compile
echo Compilation test completed.
pause
