-- CREATE TABLE statement without a PRIMARY KEY constraint:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);
-- A table created but has no MS_Description property added:
CREATE TABLE ExampleTable (
    ID INT primary key,
    Name NVARCHAR(50)
);

-- A DROP TABLE statement:
DROP TABLE ExampleTable;

-- An attempt to change password:
ALTER LOGIN [username] WITH PASSWORD = 'newpassword';
--TRUNCATE statement:
TRUNCATE TABLE ExampleTable;

-- A DROP COLUMN statement:
ALTER TABLE ExampleTable
DROP COLUMN ColumnName;

-- A GRANT TO PUBLIC statement:
GRANT SELECT ON ExampleTable TO PUBLIC;

-- GRANT WITH GRANT OPTION:

-- Flyway Migration Script for "Pubs" Database with Violations
-- This script recreates the classic Pubs database with intentional SQL Code Analysis violations.



GRANT SELECT ON ExampleTable TO [username] WITH GRANT OPTION;

-- GRANT WITH ADMIN OPTION:
GRANT ALTER ANY LOGIN TO [username] WITH ADMIN OPTION;

-- ALTER USER statement:
ALTER USER [username] WITH DEFAULT_SCHEMA = [schema_name];

-- GRANT ALL:
GRANT ALL ON ExampleTable TO [username];

-- CREATE ROLE:
CREATE ROLE ExampleRole;

-- ALTER ROLE:
ALTER ROLE ExampleRole ADD MEMBER [username];

-- DROP PARTITION:
DROP PARTITION SCHEME PartitionName;

-- CREATE TABLE statement without a PRIMARY KEY constraint:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);

-- table created that has no MS_Description property added:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);



-- Deprecated Data Types Violation (TEXT, NTEXT, IMAGE)
CREATE TABLE authors (
    au_id CHAR(11) PRIMARY KEY,
    au_lname TEXT, -- Violation: Should be VARCHAR(MAX)
    au_fname TEXT, -- Violation: Should be VARCHAR(MAX)
    phone VARCHAR(12),
    address NVARCHAR(100),
    city NTEXT, -- Violation: Should be NVARCHAR(MAX)
    state CHAR(2),
    zip CHAR(5),
    contract BIT
);

-- SELECT * Violation
SELECT * FROM authors;

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

-- Dummy Data Insertion
INSERT INTO authors (au_id, au_lname, au_fname, phone, address, city, state, zip, contract) VALUES
('172-32-1176', 'White', 'Johnson', '408 496-7223', '10932 Bigge Rd.', 'Menlo Park', 'CA', '94025', 1);

-- Flyway Regex Rules (Example TOML Configuration)
-- These should be placed in a separate file (e.g., flyway-analysis.toml)

-- [rules]
-- "no_select_star" = { pattern = "(?i)SELECT\\s+\\*", message = "Avoid using SELECT *; specify column names explicitly." }
-- "no_union_without_all" = { pattern = "(?i)UNION(?!\\s+ALL)", message = "Use UNION ALL unless duplicate removal is required." }
-- "explicit_join_type" = { pattern = "(?i)\bJOIN\b", message = "Use INNER JOIN, LEFT JOIN, or RIGHT JOIN explicitly." }
-- "avoid_right_join" = { pattern = "(?i)RIGHT\\s+JOIN", message = "Prefer LEFT JOIN for readability and maintainability." }
-- "avoid_short_aliases" = { pattern = "(?i)FROM\\s+[a-zA-Z0-9_]+\\s+[a-zA-Z]\\b", message = "Use meaningful table aliases instead of single-letter ones." }
