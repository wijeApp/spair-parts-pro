# Dashboard-Database Integration Guide

## 🔗 Linking Dashboard with MySQL Tables

Your spare parts dashboard is now fully integrated with MySQL database tables. Here's how everything works together:

### 📊 **Dashboard-Database Flow**

```
Frontend (HTML/JS) ↔ REST API ↔ Spring Boot ↔ JPA Repository ↔ MySQL Database
```

### 🗄️ **Database Tables**

#### 1. **`spare_part_items` Table**
```sql
CREATE TABLE spare_part_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    currency VARCHAR(10) DEFAULT 'LKR'
);
```

#### 2. **`users` Table**
```sql
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL
);
```

### 🔌 **API Endpoints**

The dashboard communicates with MySQL through these REST endpoints:

| Method | Endpoint | Description | Database Operation |
|--------|----------|-------------|-------------------|
| GET    | `/api/spareparts` | Get all items | `SELECT * FROM spare_part_items` |
| POST   | `/api/spareparts` | Add new item | `INSERT INTO spare_part_items` |
| PUT    | `/api/spareparts/{id}` | Update item | `UPDATE spare_part_items WHERE id=` |
| DELETE | `/api/spareparts/{id}` | Delete item | `DELETE FROM spare_part_items WHERE id=` |
| GET    | `/api/test/db-connection` | Test connection | Database health check |

### 📱 **Dashboard Features Linked to Database**

#### **Real-time Data Display**
- **Items Grid**: Shows all records from `spare_part_items` table
- **Statistics Cards**: Calculated from database data
  - Total Items: `COUNT(*) FROM spare_part_items`
  - Total Value: `SUM(price * quantity) FROM spare_part_items`
  - Low Stock: `COUNT(*) WHERE quantity < 10`
  - Average Price: `AVG(price) FROM spare_part_items`

#### **Interactive Features**
- **Add Items**: Form submits to database via POST API
- **Search**: Client-side filtering of database results
- **Real-time Updates**: Dashboard refreshes every 30 seconds
- **Connection Status**: Live indicator showing MySQL connection

#### **Data Persistence**
- All data survives application restarts
- Changes are immediately saved to MySQL
- Supports transactions and data integrity

### 🚀 **Testing the Integration**

#### **1. Check Database Connection**
```bash
# Test database connectivity
curl http://localhost:8082/api/test/db-connection
```

#### **2. Verify API Endpoints**
```bash
# Get all items
curl http://localhost:8082/api/spareparts

# Add new item
curl -X POST http://localhost:8082/api/spareparts \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Item","description":"Test","price":100.0,"quantity":5,"currency":"LKR"}'
```

#### **3. Monitor Database**
```sql
-- Connect to MySQL and check data
USE spairparts_db;
SELECT * FROM spare_part_items;
SELECT * FROM users;
```

### 🔧 **Configuration Files**

#### **Database Configuration** (`application.properties`)
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/spairparts_db
spring.datasource.username=root
spring.datasource.password=
spring.jpa.hibernate.ddl-auto=update
```

#### **Entity Classes**
- `SparePartItem.java` - Maps to `spare_part_items` table
- `User.java` - Maps to `users` table

#### **Repository Classes**
- `SparePartRepository.java` - Database operations for spare parts
- `UserRepository.java` - Database operations for users

### 📈 **Analytics Integration**

The dashboard analytics are calculated from live database data:

- **Charts**: Use database aggregations
- **Insights**: Real-time analysis of stock levels
- **Trends**: Historical data tracking (expandable)
- **Forecasting**: Based on current inventory data

### 🔒 **Security Integration**

- **Authentication**: Users stored in MySQL `users` table
- **Session Management**: Linked to database user records
- **Role-based Access**: Admin/User roles from database

### 🎯 **Sample Data**

Default data automatically loaded on startup:

```java
// 5 sample spare parts with LKR currency
new SparePartItem("Brake Pad", "High-quality brake pad", 1500.00, 50)
new SparePartItem("Oil Filter", "Durable oil filter", 800.00, 100)
new SparePartItem("Air Filter", "Efficient air filter", 1200.00, 75)
new SparePartItem("Spark Plug", "Reliable spark plug", 600.00, 200)
new SparePartItem("Battery", "Long-lasting car battery", 18000.00, 20)

// Default users
admin/admin123 (ADMIN role)
user/user123 (USER role)
```

### ✅ **Verification Checklist**

- [x] MySQL server running
- [x] Database `spairparts_db` created
- [x] Tables auto-created by JPA
- [x] Sample data loaded
- [x] API endpoints responding
- [x] Dashboard displaying data
- [x] Real-time updates working
- [x] Form submissions saving to database
- [x] Authentication working
- [x] Connection status indicator active

Your dashboard is now fully integrated with MySQL database! 🎉
