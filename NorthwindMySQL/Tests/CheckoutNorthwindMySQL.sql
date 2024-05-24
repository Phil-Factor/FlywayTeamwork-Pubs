
-- Retrieve all customers FROM dbo.the "customers" 

-- Retrieve the top 5 most expensive products FROM dbo.the "products" table:
SELECT ProductName, UnitPrice FROM dbo.products ORDER BY UnitPrice DESC;

 -- Retrieve the total number of orders for each customer:
SELECT customers.CustomerID, customers.CompanyName, COUNT(orders.OrderID) AS Totalorders
FROM dbo.customers
LEFT JOIN dbo.orders ON customers.CustomerID = orders.CustomerID
GROUP BY customers.CustomerID, customers.CompanyName;
 
 -- Retrieve the products along with their categories and suppliers:
SELECT products.ProductID, products.ProductName, categories.CategoryName, suppliers.CompanyName
FROM dbo.products
INNER JOIN dbo.categories ON products.CategoryID = categories.CategoryID
INNER JOIN dbo.suppliers ON products.SupplierID = suppliers.SupplierID;
 
 -- Retrieve the average order quantity per order:
SELECT OrderID, AVG(Quantity) AS AvgQuantity
FROM dbo.`order details`
GROUP BY OrderID;

-- SELECT * FROM dbo.information_schema.tables WHERE table_schema = 'dbo'

 -- Retrieve the top 3 customers with the highest total order amounts:
SELECT customers.CustomerID, customers.CompanyName, SUM(`order details`.UnitPrice * `order details`.Quantity) AS TotalAmount
FROM dbo.customers
INNER JOIN dbo.orders ON customers.CustomerID = orders.CustomerID
INNER JOIN dbo.`order details` ON orders.OrderID = `order details`.OrderID
GROUP BY customers.CustomerID, customers.CompanyName 
ORDER BY TotalAmount DESC
LIMIT 3;

 -- Retrieve the employees along with the number of orders they have processed:
SELECT employees.EmployeeID, employees.FirstName, employees.LastName, COUNT(orders.OrderID) AS Totalorders
FROM dbo.employees
LEFT JOIN dbo.orders ON employees.EmployeeID = orders.EmployeeID
GROUP BY employees.EmployeeID, employees.FirstName, employees.LastName;
 
 -- Retrieve the total sales amount for each category:
SELECT categories.CategoryName, SUM(`order details`.UnitPrice * `order details`.Quantity) AS TotalSalesAmount
FROM dbo.categories
INNER JOIN dbo.products ON categories.CategoryID = products.CategoryID
INNER JOIN dbo.`order details` ON products.ProductID = `order details`.ProductID
GROUP BY categories.CategoryName;

 -- Retrieve the orders placed in the year 1997:
SELECT * FROM dbo.orders WHERE YEAR(OrderDate) = 1997;
 
 -- Retrieve the customers who have not placed any orders:
SELECT customers.CustomerID, customers.CompanyName
FROM dbo.customers
LEFT JOIN dbo.orders ON customers.CustomerID = orders.CustomerID
WHERE orders.OrderID IS NULL;