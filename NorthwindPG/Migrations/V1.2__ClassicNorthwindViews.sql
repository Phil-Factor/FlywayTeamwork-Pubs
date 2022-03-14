ALTER TABLE "Order Details"
ALTER COLUMN discount SET DATA TYPE decimal USING discount::double precision;

CREATE VIEW dbo.Order_Subtotals
AS
  SELECT "Order Details".OrderID,
         Sum (
           cast ( ("Order Details".UnitPrice * Quantity * (1 - Discount) / 100)
           * 100 as money)) AS Subtotal
    FROM "Order Details"
    GROUP BY "Order Details".OrderID;
  

   
CREATE VIEW dbo.Sales_Totals_by_Amount
AS
  SELECT Order_Subtotals.Subtotal AS SaleAmount, Orders.OrderID,
         Customers.CompanyName, Orders.ShippedDate
    FROM
    Customers
      INNER JOIN(Orders
      INNER JOIN Order_Subtotals
        ON Orders.OrderID = Order_Subtotals.OrderID)
        ON Customers.CustomerID = Orders.CustomerID
    WHERE
    (Order_Subtotals.Subtotal > cast(2500 AS money))
AND (Orders.ShippedDate BETWEEN '1996-02-01' AND '1998-03-01');

  
CREATE VIEW dbo.Order_Details_Extended
AS
  SELECT "Order Details".OrderID, "Order Details".ProductID,
         Products.ProductName, "Order Details".UnitPrice,
         "Order Details".Quantity, "Order Details".Discount,
         (cast(("Order Details".UnitPrice * Quantity * (1 - Discount) / 100) as money)
          * 100) AS ExtendedPrice
    FROM
    Products
      INNER JOIN "Order Details"
        ON Products.ProductID = "Order Details".ProductID;
--ORDER BY "Order Details".OrderID
   
 
   
CREATE VIEW dbo.Sales_by_Category
AS
  SELECT categories.categoryID, categories.categoryName,
         Products.ProductName,
         Sum (Order_Details_Extended.ExtendedPrice) AS ProductSales
    FROM
    categories
      INNER JOIN(Products
      INNER JOIN(Orders
      INNER JOIN Order_Details_Extended
        ON Orders.OrderID = Order_Details_Extended.OrderID)
        ON Products.ProductID = Order_Details_Extended.ProductID)
        ON categories.categoryID = Products.categoryID
    WHERE
    Orders.OrderDate BETWEEN '1996-02-01' AND '1998-03-01'
    GROUP BY
    categories.categoryID, categories.categoryName, Products.ProductName;
	 --ORDER BY Products.ProductName
   
   
   
CREATE VIEW dbo.Summary_of_Sales_by_Quarter
AS
  SELECT Orders.ShippedDate, Orders.OrderID, Order_Subtotals.Subtotal
    FROM Orders
      INNER JOIN Order_Subtotals
        ON Orders.OrderID = Order_Subtotals.OrderID
    WHERE Orders.ShippedDate IS NOT NULL;
--ORDER BY Orders.ShippedDate
   
   
CREATE VIEW dbo.Summary_of_Sales_by_Year
AS
  SELECT Orders.ShippedDate, Orders.OrderID, Order_Subtotals.Subtotal
    FROM
    Orders
      INNER JOIN Order_Subtotals
        ON Orders.OrderID = Order_Subtotals.OrderID
    WHERE Orders.ShippedDate IS NOT NULL;
--ORDER BY Orders.ShippedDate
   
   
CREATE VIEW dbo.Product_Sales_for_1997
AS
  SELECT categories.categoryName, Products.ProductName,
         Sum (
           cast ( ("Order Details".UnitPrice * Quantity * (1 - Discount) / 100)
           * 100 as money)) AS ProductSales
    FROM(categories
      INNER JOIN Products
        ON categories.categoryID = Products.categoryID)
      INNER JOIN(Orders
      INNER JOIN "Order Details" AS "Order Details"
        ON Orders.OrderID = "Order Details".OrderID)
        ON Products.ProductID = "Order Details".ProductID
    WHERE (((Orders.ShippedDate) BETWEEN '19970101' AND '19971231'))
    GROUP BY
    categories.categoryName, Products.ProductName;
   
   
   
CREATE VIEW dbo.category_Sales_for_1997
AS
  SELECT Product_Sales_for_1997.categoryName,
         Sum (Product_Sales_for_1997.ProductSales) AS categorySales
    FROM Product_Sales_for_1997
    GROUP BY Product_Sales_for_1997.categoryName;
   
   
CREATE VIEW dbo.Alphabetical_list_of_products
AS
  SELECT Products.*, categories.categoryName
    FROM
    categories
      INNER JOIN Products
        ON categories.categoryID = Products.categoryID
    WHERE (((Products.Discontinued) = 0));
   
  
CREATE VIEW dbo.Current_Product_List
AS
  SELECT Product_List.ProductID, Product_List.ProductName
    FROM Products AS Product_List
    WHERE (((Product_List.Discontinued) = 0));
--ORDER BY Product_List.ProductName
   
   
CREATE VIEW dbo.Customer_and_Suppliers_by_City
AS
  SELECT City, CompanyName, ContactName, 'Customers' AS Relationship FROM
  Customers
  UNION
  SELECT City, CompanyName, ContactName, 'Suppliers' FROM Suppliers;
--ORDER BY City, CompanyName
 
   
CREATE VIEW dbo.Invoices
AS
  SELECT Orders.ShipName, Orders.ShipAddress, Orders.ShipCity,
         Orders.ShipRegion, Orders.ShipPostalCode, Orders.ShipCountry,
         Orders.CustomerID, Customers.CompanyName AS CustomerName,
         Customers.Address, Customers.City, Customers.Region,
         Customers.PostalCode, Customers.Country,
         --(FirstName + ' ' + LastName) AS Salesperson, 
			Orders.OrderID,
         Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate,
         Shippers.CompanyName AS ShipperName, "Order Details".ProductID,
         Products.ProductName, "Order Details".UnitPrice,
         "Order Details".Quantity, "Order Details".Discount,
         cast ( ("Order Details".UnitPrice * Quantity * (1 - Discount) / 100)
           * 100 as money) AS ExtendedPrice, Orders.Freight
    FROM
    Shippers
      INNER JOIN(Products
      INNER JOIN((Employees
      INNER JOIN(Customers
      INNER JOIN Orders
        ON Customers.CustomerID = Orders.CustomerID)
        ON Employees.EmployeeID = Orders.EmployeeID)
      INNER JOIN "Order Details"
        ON Orders.OrderID = "Order Details".OrderID)
        ON Products.ProductID = "Order Details".ProductID)
        ON Shippers.ShipperID = Orders.ShipVia;
   
 
   
CREATE VIEW dbo.Orders_Qry
AS
  SELECT Orders.OrderID, Orders.CustomerID, Orders.EmployeeID,
         Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate,
         Orders.ShipVia, Orders.Freight, Orders.ShipName, Orders.ShipAddress,
         Orders.ShipCity, Orders.ShipRegion, Orders.ShipPostalCode,
         Orders.ShipCountry, Customers.CompanyName, Customers.Address,
         Customers.City, Customers.Region, Customers.PostalCode,
         Customers.Country
    FROM
    Customers
      INNER JOIN Orders
        ON Customers.CustomerID = Orders.CustomerID;
   
/****** Object:  View [dbo].[Products Above Average Price]    Script Date: 11/03/2022 14:43:29 ******/
   
   
   
   
CREATE VIEW dbo.Products_Above_Average_Price
AS
  SELECT Products.ProductName, Products.UnitPrice
    FROM Products
    WHERE Products.UnitPrice > (SELECT Avg (UnitPrice) FROM Products);
--ORDER BY Products.UnitPrice DESC
   
/****** Object:  View [dbo].[Products by category]    Script Date: 11/03/2022 14:43:29 ******/
   
   
   
   
CREATE VIEW dbo.Products_by_category
AS
  SELECT categories.categoryName, Products.ProductName,
         Products.QuantityPerUnit, Products.UnitsInStock,
         Products.Discontinued
    FROM
    categories
      INNER JOIN Products
        ON categories.categoryID = Products.categoryID
    WHERE Products.Discontinued <> 1;
--ORDER BY categories.categoryName, Products.ProductName
   
/****** Object:  View [dbo].[Quarterly Orders]    Script Date: 11/03/2022 14:43:29 ******/
   
   
   
   
CREATE VIEW dbo.Quarterly_Orders
AS
  SELECT DISTINCT Customers.CustomerID, Customers.CompanyName,
                  Customers.City, Customers.Country
    FROM
    Customers
      RIGHT JOIN Orders
        ON Customers.CustomerID = Orders.CustomerID
    WHERE
    Orders.OrderDate BETWEEN '19970101' AND '19971231';
   
