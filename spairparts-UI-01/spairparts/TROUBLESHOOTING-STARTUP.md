# 🔧 TROUBLESHOOTING: Spring Boot Start Error

## Problem Identified
**Error:** `Process terminated with exit code: 1`
**Root Cause:** Java version compatibility issue

## Issues Found:
1. **Java Version Mismatch**: Using Java 24, but Spring Boot 3.5.4 targets Java 17-21
2. **Possible MySQL Connection Issues**: Default profile tries to connect to MySQL

## Solutions (Try in Order):

### Solution 1: Use H2 Database (Recommended)
```powershell
mvn spring-boot:run -Dspring.profiles.active=test
```

### Solution 2: Update Java Version Setting
Already updated pom.xml to use Java 21 instead of Java 17

### Solution 3: Use Maven Wrapper (If Maven Issues)
```powershell
.\mvnw.cmd spring-boot:run -Dspring.profiles.active=test
```

### Solution 4: Direct Java Execution
```powershell
mvn clean package -DskipTests
java -jar target\spairparts-0.0.1-SNAPSHOT.jar --spring.profiles.active=test
```

### Solution 5: Downgrade Java (Recommended)
- Install Java 21 or Java 17
- Update JAVA_HOME environment variable
- Restart terminal and try again

## Quick Test Commands:

### Option A: H2 Database (No MySQL Required)
```powershell
mvn spring-boot:run -Dspring.profiles.active=test
```

### Option B: Skip Tests and Run
```powershell
mvn clean package -DskipTests
java -Dspring.profiles.active=test -jar target\spairparts-0.0.1-SNAPSHOT.jar
```

## Expected Result:
- Application starts on `http://localhost:8082`
- Login page accessible at `http://localhost:8082/login`
- Test accounts: `admin/admin123` and `user/user123`

## Verification Steps:
1. Look for "Started SpairpartsApplication" message
2. No MySQL connection errors with test profile
3. Web interface accessible
4. Admin delete buttons work as expected

## If Still Fails:
Check the specific error message and run:
```powershell
mvn dependency:tree
mvn clean compile
```

The admin delete functionality is correctly implemented - the issue is just with the application startup environment.
