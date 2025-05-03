

 --  Question 1
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(100)
);
INSERT INTO ProductDetail(OrderID, CustomerName, Products)
VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- - In the table above, the **Products column** contains multiple values, which violates **1NF**.
-- - **Write an SQL query** to transform this table into **1NF**, ensuring that each row represents a single product for an order
--  Question 1 - Solution
-- Create a new table to store products in 1NF
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Insert data into the 1NF table, splitting the Products column
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, value
FROM ProductDetail
CROSS APPLY STRING_SPLIT(Products, ',');

-- Verify the transformed table
SELECT * FROM ProductDetail_1NF;


-- Question 2
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);
INSERT INTO Orders (OrderID, CustomerName)
VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');


CREATE TABLE Product (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
INSERT INTO Product (OrderID, Product, Quantity)
VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);
-- - In the table above, the **CustomerName** column depends on **OrderID** (a partial dependency), which violates **2NF**. 

-- - Write an SQL query to transform this table into **2NF** by removing partial dependencies. Ensure that each non-key column fully depends on the entire primary key.
-- Question 2 - Solution
-- Create a new table for customer information
CREATE TABLE Customer (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert customer data
INSERT INTO Customer (OrderID, CustomerName)
SELECT OrderID, CustomerName
FROM Orders;

-- Modify the Product table to remove CustomerName
ALTER TABLE Product
DROP COLUMN CustomerName;

-- Verify the transformed tables
SELECT * FROM Customer;
SELECT * FROM Product;

