CREATE DATABASE Testing;
USE Testing;

-----------------------------------------------------------------------------------------------------------------------------------------
--Question 1: List all suppliers in the UK
SELECT * FROM dbo.Supplier                                 -- Retrieves all columns from the Suppliers table to only those where supplier 
WHERE Country = 'UK';                                      -- is based in the UK. There are only two suppliers in the UK(Exotic Liquids
                                                           -- and Specialty Biscuits, Ltd.)



-----------------------------------------------------------------------------------------------------------------------------------------
--Question 2: List the first name, last name, and city for all customers. 
--Concatenate the first and last name seperated by a space and a comma as a single column.

SELECT
      CONCAT(FirstName, ' ' , LastName) AS FullName,        -- Selects the full name and city of each customer by combining the FirstName 
      City                                                  -- and LastName columns into a column called 'FullName'. The results are 
FROM dbo.Customer;                                          -- pulled from the 'Customer' table. There are 91 customers in total.



-----------------------------------------------------------------------------------------------------------------------------------------
--Question 3: List all customers in Sweden

SELECT
      CONCAT(FirstName, ' ' , LastName) AS FullName,        -- Retrieves the full names and cities of customers who are located in Sweden 
	  City                                                  -- by combining the 'FirstName' and 'LastName' columns into a column called 
FROM dbo.Customer                                           -- 'FullName'. There are only two customers from Sweden.
WHERE Country = 'Sweden';                                    


-----------------------------------------------------------------------------------------------------------------------------------------
--Question 4: List all Suppliers in alphabetical order

SELECT                                                      --This query retrieves a list of suppliers. The results are sorted in 
      Id,                                                   --ascending (A–Z) order by the 'CompanyName' column. Selected from the                                                                                        
	  CompanyName,                                          -- 'Supplier' table. There are 29 suppliers in total.
	  ContactName,                
	  City, 
	  Country
FROM dbo.Supplier
ORDER BY CompanyName ASC;



-----------------------------------------------------------------------------------------------------------------------------------------
--Question 5: List all suppliers with their products

SELECT                                                       -- Returns each product with its supplier name by joining 
      ProductName,                                           -- the Product and Supplier tables and grouping by both fields.
      CompanyName AS SupplierName
FROM dbo.Product P
JOIN dbo.Supplier S ON P.Id = S.Id
GROUP BY ProductName, CompanyName;



-----------------------------------------------------------------------------------------------------------------------------------------
--Question 6: List all orders with customer information

SELECT                                                      -- Returns the number of customers per country by grouping the  Customer table
      Country,                                              -- and counting entries per country.
	  COUNT (*) AS TotalCustomers
FROM dbo.Customer 
GROUP BY Country;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 7: List all orders with product name, quantity, and price, sorted by order number

SELECT                                                        -- Returns all orders with product name, quantity, and unit price,
	O.OrderNumber,                                            -- sorted by order ID. There are 830 orders in total.
    P.ProductName,
    OI.Quantity,
    OI.UnitPrice
FROM dbo.[Order] O
JOIN dbo.OrderItem OI ON O.Id = OI.Id
JOIN dbo.Product P ON OI.ProductId = P.Id
ORDER BY OrderNumber;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 8: Using a case statement, list all the availability of products. When 0 then not available, else available

SELECT                                                        -- Lists product name and availability using IsDiscontinued: 'Not Available' 
    ProductName,                                              -- if 1, else 'Available'. This shows products that are still in stock and
    CASE                                                      -- those finished.
        WHEN IsDiscontinued = 1 THEN 'Not Available' 
        ELSE 'Available'
    END AS Availability
FROM dbo.Product;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 9: Using case statement, list all the suppliers and the language they speak. The language they speak should be their 
-- country E.g if UK, then English

SELECT                                                         -- Lists each supplier and the language they speak, inferred from 
    CompanyName AS SupplierName,                               -- their country using CASE.
    Country,
    CASE 
        WHEN Country = 'UK' THEN 'English'
        WHEN Country = 'USA' THEN 'English'
        WHEN Country = 'Germany' THEN 'German'
        WHEN Country = 'France' THEN 'French'
        WHEN Country = 'Brazil' THEN 'Portuguese'
        ELSE 'Other'
    END AS Language
FROM dbo.Supplier;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 10: List all products that are packaged in Jars

SELECT                                                           -- Returns products whose package description contains the word 'jar'.
    ProductName,                                                 -- They are 8 in total.
    Package
FROM dbo.Product
WHERE Package LIKE '%jar%';



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 11: List products name, unitprice and packages for products that starts with Ca

SELECT                                                            -- Lists product name, unit price, and package for products 
    ProductName,                                                  -- starting with 'Ca'. There are just two products that start with Ca.
    UnitPrice,
    Package
FROM dbo.Product
WHERE ProductName LIKE 'Ca%';



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 12: List the number of products for each supplier, sorted high to low.

SELECT                                                            -- Returns a count of products grouped by supplier, sorted from
    S.CompanyName AS SupplierName,                                -- most to least. Pavlova, Ltd. and Plutzer Lebensmittelgroßmärkte AG
    COUNT(P.Id) AS TotalProducts                                  -- have the highest number of products which is 5.
FROM dbo.Supplier S
JOIN dbo.Product P ON S.Id = P.SupplierId
GROUP BY S.CompanyName
ORDER BY TotalProducts DESC;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 13: List the number of customers in each country.

SELECT                                                           -- Returns the number of customers grouped by country. 
    Country,                                                    
    COUNT(*) AS TotalCustomers                                   
FROM dbo.Customer
GROUP BY Country;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 14: List the number of customers in each country, sorted high to low.

SELECT                                                            -- Returns customer count per country, sorted from highest to lowest.
    Country,                                                      -- USA has the highest number of customers(13), followed by France and
    COUNT(*) AS TotalCustomers                                    -- Germany who have 11 customers each.
FROM dbo.Customer
GROUP BY Country
ORDER BY TotalCustomers DESC;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 15: List the total order amount for each customer, sorted high to low.

SELECT                                                             -- Shows total order amount per customer by summing each order’s 
    C.FirstName + ' ' + C.LastName AS CustomerName,                -- total, sorted descending. Horst Kloss has the highest order amount.
    SUM(OI.Quantity * OI.UnitPrice) AS TotalOrderAmount
FROM dbo.Customer C
JOIN dbo.[Order] O ON C.Id = O.CustomerId
JOIN dbo.OrderItem OI ON O.Id = OI.OrderId
GROUP BY C.FirstName, C.LastName
ORDER BY TotalOrderAmount DESC;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 16: List all countries with more than 2 suppliers.

SELECT                                                            -- Returns countries that have more than 2 suppliers. They are just 3
    Country,                                                      -- namely; France (3 suppliers), Germany (3 suppliers) and 
    COUNT(*) AS TotalSuppliers                                    -- USA (4 suppliers).
FROM dbo.Supplier
GROUP BY Country
HAVING COUNT(*) > 2;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 17: List the number of customers in each country. Only include countries with more than 10 customers.

SELECT                                                            -- Returns only countries with more than 10 customers. They are just 3
    Country,                                                      -- namely; France (11), Germany (11) and USA (13).
    COUNT(*) AS TotalCustomers
FROM dbo.Customer
GROUP BY Country
HAVING COUNT(*) > 10;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 18: List the number of customers in each country, except the USA, sorted high to low. Only include countries with 9 or 
-- more customers.

SELECT                                                             -- Lists countries (excluding USA) with at least 9 customers, 
    Country,                                                       -- sorted by count descending. They are 3; France (11), Germany (11)
    COUNT(*) AS TotalCustomers                                     -- and Brazil (9).
FROM dbo.Customer
WHERE Country != 'USA'
GROUP BY Country
HAVING COUNT(*) >= 9
ORDER BY TotalCustomers DESC;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 19: List customer with average orders between $1000 and $1200.

SELECT                                                             -- Shows customers whose average order total falls between $1000 
    C.FirstName + ' ' + C.LastName AS CustomerName,                -- and $1200. There are 5 customers whose average order total falls 
    AVG(OI.Quantity * OI.UnitPrice) AS AvgOrderAmount              -- within that range.
FROM dbo.Customer C
JOIN dbo.[Order] O ON C.Id = O.CustomerId
JOIN dbo.OrderItem OI ON O.Id = OI.OrderId
GROUP BY C.FirstName, C.LastName
HAVING AVG(OI.Quantity * OI.UnitPrice) BETWEEN 1000 AND 1200;



-----------------------------------------------------------------------------------------------------------------------------------------
-- Question 20: Get the number of orders and total amount sold between Jan 1, 2013 and Jan 31, 2013.

SELECT                                                            -- Returns total number of orders and total amount sold in January 2013
    COUNT(DISTINCT O.Id) AS TotalOrders,                          -- which is a total order of 33 with sales amount of $66692.80.
    SUM(OI.Quantity * OI.UnitPrice) AS TotalSales
FROM dbo.[Order] O
JOIN dbo.OrderItem OI ON O.Id = OI.OrderId
WHERE O.OrderDate BETWEEN '2013-01-01' AND '2013-01-31';