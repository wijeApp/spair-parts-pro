-- MySQL Test Database Setup Script
-- Run this script before running tests

-- Create test database
CREATE DATABASE IF NOT EXISTS spareparts_test;

-- Grant permissions (if using a specific user)
-- GRANT ALL PRIVILEGES ON spareparts_test.* TO 'root'@'localhost';
-- FLUSH PRIVILEGES;

USE spareparts_test;

-- Tables will be created automatically by Spring Boot JPA with ddl-auto=create-drop
-- This script just ensures the database exists
