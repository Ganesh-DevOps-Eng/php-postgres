-- Create the database
CREATE DATABASE mydb;

-- Connect to the database
\c mydb;

-- Create a table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    salary NUMERIC(10, 2) NOT NULL
);

-- Insert sample data
INSERT INTO employees (name, position, salary) VALUES 
('Alice', 'Developer', 75000),
('Bob', 'Manager', 85000),
('Carol', 'Designer', 70000);
