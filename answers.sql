-- ### Question 1 Achieving 1NF (First Normal Form) 🛠️

WITH
  ProductDetail AS (
    SELECT
      101 AS OrderID,
      'John Doe' AS CustomerName,
      'Laptop, Mouse' AS Products
    UNION ALL
    SELECT
      102,
      'Jane Smith',
      'Tablet, Keyboard, Mouse'
    UNION ALL
    SELECT
      103,
      'Emily Clark',
      'Phone'
  ),
  -- Recursive CTE to split the Products string into individual products
  RecursiveSplit AS (
    SELECT
      OrderID,
      CustomerName,
      Products,
      1 AS position,
      ',' AS delimiter,
      Products || ',' AS full_string
    FROM ProductDetail
    UNION ALL
    SELECT
      OrderID,
      CustomerName,
      SUBSTR(
        full_string,
        1,
        INSTR(full_string, delimiter) - 1
      ),
      position + 1,
      delimiter,
      SUBSTR(
        full_string,
        INSTR(full_string, delimiter) + 1
      )
    FROM RecursiveSplit
    WHERE
      INSTR(full_string, delimiter) > 0
  )
SELECT
  OrderID,
  CustomerName,
  TRIM(ProductName) AS ProductName
FROM
  RecursiveSplit
WHERE
  LENGTH(TRIM(ProductName)) > 0;



  
-- ### Question 2 Achieving 2NF (Second Normal Form) 🧩

-- Create the Orders table
CREATE TABLE Orders AS
SELECT DISTINCT
  OrderID,
  CustomerName
FROM OrderDetails;
ALTER TABLE Orders ADD PRIMARY KEY (OrderID);

-- Create the OrderProducts table
CREATE TABLE OrderProducts AS
SELECT
  OrderID,
  Product,
  Quantity
FROM OrderDetails;
ALTER TABLE OrderProducts ADD PRIMARY KEY (OrderID, Product);
ALTER TABLE OrderProducts ADD FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);

-- Display the new tables
SELECT
  *
FROM Orders;
SELECT
  *
FROM OrderProducts;
