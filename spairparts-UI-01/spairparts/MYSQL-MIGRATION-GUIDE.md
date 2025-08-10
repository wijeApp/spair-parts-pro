# Spare Parts Management System - Database Migration Guide

## Migration from H2 to MySQL

This project has been migrated from H2 in-memory database to MySQL for production use.

### Prerequisites

1. **MySQL Server**: Install MySQL 8.0 or later
   - Download from: https://dev.mysql.com/downloads/mysql/
   - Or use Docker: `docker run --name mysql-spairparts -e MYSQL_ROOT_PASSWORD=yourpassword -p 3306:3306 -d mysql:8.0`

### Database Setup

1. **Create Database**:
   ```sql
   CREATE DATABASE spairparts_db;
   ```

2. **Create User (Optional)**:
   ```sql
   CREATE USER 'spairparts_user'@'localhost' IDENTIFIED BY 'spairparts_password';
   GRANT ALL PRIVILEGES ON spairparts_db.* TO 'spairparts_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. **Or run the setup script**:
   ```bash
   mysql -u root -p < src/main/resources/mysql-setup.sql
   ```

### Configuration

Update the database credentials in your application properties:

#### Development (`application-dev.properties`):
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/spairparts_db
spring.datasource.username=root
spring.datasource.password=yourpassword
```

#### Production (`application-prod.properties`):
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/spairparts_prod
spring.datasource.username=${DB_USERNAME:spairparts_user}
spring.datasource.password=${DB_PASSWORD:spairparts_password}
```

### Environment Variables (Production)

Set these environment variables for production:
```bash
export DB_USERNAME=spairparts_user
export DB_PASSWORD=spairparts_password
```

### Running the Application

1. **Development Mode**:
   ```bash
   mvn spring-boot:run -Dspring-boot.run.profiles=dev
   ```

2. **Production Mode**:
   ```bash
   mvn spring-boot:run -Dspring-boot.run.profiles=prod
   ```

3. **Default Mode** (uses main application.properties with MySQL):
   ```bash
   mvn spring-boot:run
   ```

### Database Schema

The application uses JPA with `ddl-auto=update` in development and `ddl-auto=validate` in production.

Tables created automatically:
- `users` - User authentication data
- `spare_part_items` - Spare parts inventory

### Sample Data

The application automatically creates:
- Default admin user: `admin/admin123`
- Default regular user: `user/user123`
- 5 sample spare part items with LKR currency

### Troubleshooting

1. **Connection Issues**:
   - Ensure MySQL service is running
   - Check firewall settings
   - Verify database exists

2. **Authentication Issues**:
   - Check username/password
   - Ensure user has proper privileges
   - Try with root user first

3. **SSL Issues**:
   - For development, SSL is disabled
   - For production, ensure proper SSL configuration

### Docker Setup (Alternative)

If you prefer Docker for MySQL:

```bash
# Start MySQL container
docker run --name mysql-spairparts \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=spairparts_db \
  -e MYSQL_USER=spairparts_user \
  -e MYSQL_PASSWORD=spairparts_password \
  -p 3306:3306 \
  -d mysql:8.0

# Wait for container to be ready, then run the application
mvn spring-boot:run
```

### Changes Made

1. **Removed H2 dependency** from `pom.xml`
2. **Added MySQL connector** dependency
3. **Updated application.properties** with MySQL configuration
4. **Created environment-specific** configurations
5. **Added database setup scripts**

The application is now ready for production use with MySQL database!
