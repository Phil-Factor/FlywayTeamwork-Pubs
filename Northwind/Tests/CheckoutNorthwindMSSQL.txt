-- Retrieve all customers from the "Customers" table:
SELECT * FROM Customers;

-- Retrieve the top 5 most expensive products from the "Products" table:
SELECT TOP 5 ProductName, UnitPrice FROM Products ORDER BY UnitPrice DESC;

-- Retrieve the total number of orders for each customer:
SELECT Customers.CustomerID, Customers.CompanyName, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.CompanyName;

-- Retrieve the products along with their categories and suppliers:
SELECT Products.ProductID, Products.ProductName, Categories.CategoryName, Suppliers.CompanyName
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID;

-- Retrieve the average order quantity per order:
SELECT OrderID, AVG(Quantity) AS AvgQuantity
FROM [Order Details]
GROUP BY OrderID;

-- Retrieve the top 3 customers with the highest total order amounts:
SELECT TOP 3 Customers.CustomerID, Customers.CompanyName, SUM([Order Details].UnitPrice * [Order Details].Quantity) AS TotalAmount
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Customers.CustomerID, Customers.CompanyName
ORDER BY TotalAmount DESC;

-- Retrieve the employees along with the number of orders they have processed:
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS TotalOrders
FROM Employees
LEFT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, Employees.FirstName, Employees.LastName;

-- Retrieve the total sales amount for each category:
SELECT Categories.CategoryName, SUM([Order Details].UnitPrice * [Order Details].Quantity) AS TotalSalesAmount
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
GROUP BY Categories.CategoryName;

-- Retrieve the orders placed in the year 1997:
SELECT * FROM Orders WHERE YEAR(OrderDate) = 1997;

-- Retrieve the customers who have not placed any orders:
SELECT Customers.CustomerID, Customers.CompanyName
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NULL;