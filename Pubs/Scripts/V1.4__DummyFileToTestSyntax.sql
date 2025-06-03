-- Deprecated Data Types Violation (TEXT, NTEXT, IMAGE)
CREATE TABLE authors (
    au_id CHAR(11) PRIMARY KEY,
    au_lname TEXT, -- Violation: Should be VARCHAR(MAX)
    au_fname TEXT, -- Violation: Should be VARCHAR(MAX)
    phone CHAR(12),
    address NVARCHAR(100),
    city NTEXT, -- Violation: Should be NVARCHAR(MAX)
    state CHAR(2),
    zip CHAR(5),
    contract BIT
);

--Detecting Unqualified Column Names in Joins

--Good SQL:
SELECT Orders.OrderID, Customers.CustomerName 
FROM Orders 
JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

-- Bad SQL (Flyway should flag OrderID, CustomerName as ambiguous):

SELECT OrderID, CustomerName 
FROM Orders 
INNER JOIN Customers ON CustomerID = CustomerID;
--
SELECT OrderID, CustomerName 
FROM Orders 
JOIN Customers ON CustomerID = CustomerID;
--
-- a join 
Select * FROM Orders 
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

-- but this is fine (another rule (No Star) can be used for this)
Select * from orders

-- and so is this
SELECT Orders.OrderID, Customers.CustomerName 
FROM Orders 


-- SELECT * Violation
SELECT * FROM authors;
Select au_fname+' '+au_lname, title 
from authors,TitleAuthor,publications 
where authors.au_id=TitleAuthor.au_id 
and publications.Publication_id =TitleAuthor.title_id


-- SET IDENTITY_INSERT ON Violation
SET IDENTITY_INSERT authors ON;

-- GO inside stored procedure violation
CREATE PROCEDURE sp_get_authors
AS
BEGIN
    SELECT * FROM authors;
    GO -- Violation: GO should not be inside a stored procedure
END;

-- Missing SET NOCOUNT ON in Stored Procedure
CREATE PROCEDURE sp_get_titles
AS
BEGIN
    SELECT * FROM titles;
END;

-- Naming Conventions Violations (PK_, FK_, IX_ Prefixes Missing)
CREATE TABLE titles (
    title_id CHAR(6) CONSTRAINT title_pk PRIMARY KEY, -- Violation: Should be 'PK_titles'
    title TEXT,
    type CHAR(12),
    pub_id CHAR(4) CONSTRAINT pub_fk REFERENCES publishers(pub_id), -- Violation: Should be 'FK_publishers_pub_id'
    price MONEY,
    notes TEXT,
    pubdate DATETIME
);
Drop table theNaughtyTable

Truncate table theNaughtyTable

ALTER TABLE theNaughtyTable
DROP COLUMN TableName;
-- Todo - Run the Flyway error check
Grant select on Naughtyyable to maria,public;

GRANT
 SELECT, UPDATE ON items TO mary WITH GRANT OPTION;

-- Index Naming Violation
CREATE INDEX title_index ON titles(title); -- Violation: Should be 'IX_titles_title'

-- UNION instead of UNION ALL Violation
SELECT title FROM titles
UNION 
SELECT title FROM titles; -- Violation: Prefer UNION ALL unless explicitly removing duplicates

-- Be explicit about JOIN type Violation
SELECT a.au_id, t.title
FROM authors a
JOIN titles t ON a.au_id = t.pub_id; -- Violation: Should be INNER JOIN

-- Right Join instead of Left Join Violation
SELECT t.title, p.pub_name
FROM titles t
RIGHT JOIN publishers p ON t.pub_id = p.pub_id; -- Violation: Prefer LEFT JOIN for readability

-- Short Table Alias Violation
SELECT c.au_id, c.au_lname
FROM authors c; -- Violation: Use 'authors' instead of 'c' for clarity

-- Right Join instead of Left Join Violation
SELECT t.title, p.pub_name
FROM titles,publishers p ON t.pub_id = p.pub_id; -- Use explicit `JOIN` instead of comma joins.

-- Dummy Data Insertion
INSERT INTO authors (au_id, au_lname, au_fname, phone, address, city, state, zip, contract) VALUES
('172-32-1176', 'White', 'Johnson', '408 496-7223', '10932 Bigge Rd.', 'Menlo Park', 'CA', '94025', 1);

--CREATE TABLE statement without a PRIMARY KEY constraint:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);
--A table created but has no MS_Description property added:
CREATE TABLE ExampleTable (
    ID INT primary key,
    Name NVARCHAR(50)
);
--A DROP TABLE statement:
DROP TABLE ExampleTable;
--An attempt to change password:
ALTER LOGIN [username] WITH PASSWORD = 'newpassword';
--TRUNCATE statement:
TRUNCATE TABLE ExampleTable;

--A DROP COLUMN statement:
ALTER TABLE ExampleTable
DROP COLUMN ColumnName;
--A GRANT TO PUBLIC statement:
GRANT SELECT ON ExampleTable TO PUBLIC;
--GRANT WITH GRANT OPTION:
GRANT SELECT ON ExampleTable TO [username] WITH GRANT OPTION;
--GRANT WITH ADMIN OPTION:
GRANT ALTER ANY LOGIN TO [username] WITH ADMIN OPTION;
--ALTER USER statement:
ALTER USER [username] WITH DEFAULT_SCHEMA = [schema_name];
--GRANT ALL:
GRANT ALL ON ExampleTable TO [username];
--CREATE ROLE:
CREATE ROLE ExampleRole;
--ALTER ROLE:
ALTER ROLE ExampleRole ADD MEMBER [username];
--DROP PARTITION:
DROP PARTITION SCHEME PartitionName;
--CREATE TABLE statement without a PRIMARY KEY constraint:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);
-- table created that has no MS_Description property added:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);
