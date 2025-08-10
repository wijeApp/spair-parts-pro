-- MySQL Database Setup Script for Spare Parts Management System
-- Run this script in MySQL to create the database and user

-- Create database
CREATE DATABASE IF NOT EXISTS spairparts_db;
USE spairparts_db;

-- Create user (optional - you can use root)
-- CREATE USER 'spairparts_user'@'localhost' IDENTIFIED BY 'spairparts_password';
-- GRANT ALL PRIVILEGES ON spairparts_db.* TO 'spairparts_user'@'localhost';
-- FLUSH PRIVILEGES;

-- The tables will be automatically created by Spring Boot JPA with ddl-auto=update
-- But here's the manual schema if needed:

/*
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS spare_part_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    currency VARCHAR(10) DEFAULT 'LKR',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Index for better performance
CREATE INDEX idx_spare_parts_name ON spare_part_items(name);
CREATE INDEX idx_users_username ON users(username);
*/
