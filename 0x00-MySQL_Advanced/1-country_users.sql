-- Script to create a table named 'users' with specified attributes including an enumeration for the 'country' column
-- This script creates the 'users' table if it does not already exist.
-- The table has four columns:
-- - id: An integer, never null, auto increment, and primary key
-- - email: A string (255 characters), never null, and unique
-- - name: A string (255 characters)
-- - country: An enumeration ('ENUM') of countries ('US', 'CO', 'TN'), never null, with a default value of 'US'

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    country ENUM('US', 'CO', 'TN') NOT NULL DEFAULT 'US',
    PRIMARY KEY (id)
);

