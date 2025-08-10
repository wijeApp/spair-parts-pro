# 🗄️ MySQL Database Setup Guide

## Overview
This guide will help you create the MySQL table for the `SparePartItem` entity and populate it with sample data.

## 📋 Prerequisites
- MySQL Server 8.0+ installed and running
- MySQL credentials: username=`root`, password=`myRoot@123` (as configured in application-dev.properties)

## 🚀 Quick Setup Options

### Option 1: Automated Setup (Recommended)
Run the automated setup script:

#### Windows (PowerShell):
```powershell
.\setup-mysql-database.ps1
```

#### Windows (Command Prompt):
```cmd
setup-mysql-database.bat
```

### Option 2: Manual Setup in MySQL Workbench
1. Open MySQL Workbench
2. Connect to your MySQL server
3. Open and execute: `src\main\resources\quick-setup.sql`

### Option 3: Command Line Setup
```bash
mysql -u root -p"myRoot@123" < src\main\resources\create-tables-and-data.sql
```

## 📊 What Gets Created

### Tables:
1. **spare_part_items** - Main inventory table
2. **users** - Authentication table

### Sample Data:
- **10 spare part items** with realistic data
- **3 sample users** (admin, manager, user)

## 🔍 Table Structure

### spare_part_items table:
```sql
CREATE TABLE spare_part_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000),
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    currency VARCHAR(10) DEFAULT 'LKR',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Sample Data Preview:
| ID | Name | Price | Quantity |
|----|------|-------|----------|
| 1 | Engine Oil Filter | 2599.99 | 50 |
| 2 | Brake Pads Set | 8999.99 | 25 |
| 3 | Air Filter | 1550.00 | 100 |
| 4 | Spark Plugs (Set of 4) | 4500.00 | 75 |
| 5 | Transmission Fluid | 3525.00 | 30 |

## ✅ Verification

After setup, verify with these commands:

```sql
-- Check database and tables
USE spareparts_db;
SHOW TABLES;

-- Check data
SELECT COUNT(*) as 'Total Items' FROM spare_part_items;
SELECT name, price, quantity FROM spare_part_items LIMIT 5;

-- Check users
SELECT username, role FROM users;
```

## 🚀 Running the Application

After database setup:

1. **Start the application:**
   ```bash
   mvn spring-boot:run -Dspring-boot.run.profiles=dev
   ```

2. **Access the dashboard:**
   http://localhost:8082/dashboard

3. **Login with sample users:**
   - Username: `admin`, Password: `admin123`
   - Username: `user`, Password: `user123`

## 🔧 Troubleshooting

### Connection Issues:
- Verify MySQL is running: `net start mysql`
- Check credentials in `application-dev.properties`
- Test connection: `mysql -u root -p"myRoot@123"`

### Table Creation Issues:
- Ensure database `spareparts_db` exists
- Check user permissions
- Verify SQL syntax in error messages

### Data Loading Issues:
- Check for duplicate key errors
- Verify table structure matches entity
- Review Spring Boot logs for SQL errors

## 📁 Files Created:
- `create-tables-and-data.sql` - Complete setup script
- `quick-setup.sql` - Simple manual setup
- `setup-mysql-database.bat` - Windows batch script
- `setup-mysql-database.ps1` - PowerShell script

Your database is now ready for the Spare Parts Management System! 🎉
