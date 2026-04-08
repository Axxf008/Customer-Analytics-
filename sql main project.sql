CREATE DATABASE Customer_Analytics;
USE Customer_Analytics;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    city VARCHAR(50),
    join_date DATE,
    membership_type VARCHAR(20)
);
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    transaction_date DATE,
    payment_mode VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Membership_Plans (
    plan_id INT PRIMARY KEY,
    membership_type VARCHAR(20),
    monthly_fee DECIMAL(10,2),
    benefits VARCHAR(100)
);
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA LOCAL INFILE 'C:/data/sql_project_dataset.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) AS total_customers FROM Customers;

SELECT SUM(amount) AS total_revenue FROM Transactions;

SELECT AVG(amount) AS avg_transaction FROM Transactions;

SELECT membership_type, COUNT(*) AS total
FROM Customers
GROUP BY membership_type;

SELECT payment_mode, SUM(amount) AS revenue
FROM Transactions
GROUP BY payment_mode;

SELECT 
    MONTH(transaction_date) AS month,
    SUM(amount) AS revenue
FROM Transactions
GROUP BY MONTH(transaction_date)
ORDER BY month;

SELECT 
    c.name,
    c.city,
    c.membership_type,
    t.amount,
    t.payment_mode,
    m.monthly_fee
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
JOIN Membership_Plans m ON c.membership_type = m.membership_type;

SELECT 
    c.name,
    SUM(t.amount) AS total_spent
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 5;

SELECT 
    c.customer_id,
    c.name,
    SUM(t.amount) AS lifetime_value
FROM Customers c
LEFT JOIN Transactions t 
ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name;

SELECT membership_type, COUNT(*) AS total_users
FROM Customers
GROUP BY membership_type
ORDER BY total_users DESC
LIMIT 1;

SELECT 
    c.city,
    SUM(t.amount) AS total_revenue
FROM Customers c
JOIN Transactions t 
ON c.customer_id = t.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;

SELECT 
    customer_id,
    COUNT(transaction_id) AS total_transactions
FROM Transactions
GROUP BY customer_id
HAVING COUNT(transaction_id) > 1;

CREATE VIEW Customer_Summary AS
SELECT 
    c.customer_id,
    c.name,
    SUM(t.amount) AS total_spent
FROM Customers c
LEFT JOIN Transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name;





