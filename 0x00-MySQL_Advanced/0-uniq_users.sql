-- Script to create a table named 'users' with specified attributes
-- This script creates the 'users' table if it does not already exist.
-- The table has three columns:
-- - id: An integer, never null, auto increment, and primary key
-- - email: A string (255 characters), never null, and unique
-- - name: A string (255 characters)

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    PRIMARY KEY (id)
);

