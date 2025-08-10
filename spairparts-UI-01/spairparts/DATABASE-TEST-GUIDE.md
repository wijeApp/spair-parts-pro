## Database Connection Test Results

Run this command to test the database connection:

```cmd
java -jar target\spairparts-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev
```

**Expected behavior:**
1. Application should start successfully
2. Connect to MySQL database at localhost:3306
3. Create/update tables automatically (ddl-auto=create)
4. Load sample data from data.sql
5. Start Tomcat server on port 8082

**If you see errors:**

### Common Error 1: "Communications link failure"
- MySQL server is not running
- Incorrect port (should be 3306)
- Firewall blocking connection

### Common Error 2: "Access denied for user 'root'"
- Incorrect password (should be myRoot@123)
- User doesn't exist or lacks privileges

### Common Error 3: "Unknown database 'spareparts_db'"
- Database doesn't exist
- Run: `CREATE DATABASE spareparts_db;` in MySQL

### Common Error 4: "Table 'spare_part_items' doesn't exist"
- Hibernate didn't create tables
- Check ddl-auto setting (should be 'create' or 'update')

**Manual Database Setup:**
If automatic setup fails, manually run these SQL commands:

```sql
CREATE DATABASE IF NOT EXISTS spareparts_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE spareparts_db;

CREATE TABLE spare_part_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000),
    price DOUBLE NOT NULL,
    quantity INT NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    created_at DATETIME,
    updated_at DATETIME
);
```

**Testing Steps:**
1. Start the application
2. Go to http://localhost:8082
3. Login with any credentials (or register)
4. Try adding a new spare part through the UI
5. Check database: `SELECT * FROM spare_part_items;`
