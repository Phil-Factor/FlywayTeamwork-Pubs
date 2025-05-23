
/* Act */
--Retrieve all titles along with the number of authors for each title
SELECT title.title_id, title.title, Count (*) AS author_count
  FROM
  titles title
    LEFT JOIN titleauthor ta
      ON title.title_id = ta.title_id
  GROUP BY
  title.title_id, title.title;

Go
--simply listing all titles, authors firstnames, surnames , and title_id 
--a title can have several authors

SELECT title.title, au.au_fname, au.au_lname, title.title_id
  FROM
  authors au
    INNER JOIN titleauthor ta
      ON au.au_id = ta.au_id
    INNER JOIN titles title
      ON ta.title_id = title.title_id;
go

--Retrieve all authors and their respective titles:
SELECT au.au_id, title.title,
       Concat (au.au_fname, ' ', au.au_lname) AS Author, title.title_id
  FROM
  authors au
    INNER JOIN titleauthor ta
      ON au.au_id = ta.au_id
    INNER JOIN titles title
      ON ta.title_id = title.title_id;

Go
-- All the books with the maximum number of co-authors
SELECT title.title_id, title.title, String_Agg(Concat (au.au_fname, ' ', au.au_lname), ', ')
   FROM
       authors au
         INNER JOIN titleauthor ta
           ON au.au_id = ta.au_id
         INNER JOIN titles title
           ON ta.title_id = title.title_id		  
  GROUP BY  title,title.title_id
  HAVING Count(au.au_id) =
(SELECT Max(authorcount) AS Max_Co_authors FROM 
	(SELECT title.title_id, Count (*) AS authorCount
		FROM titles title
			LEFT JOIN titleauthor ta
			  ON title.title_id = ta.title_id
		  GROUP BY
		  title.title_id)g)
ORDER BY title.title
Go

--provide a list of authors, the number of titles, and a list of titles
SELECT f.Author AS "The Author", Count (title) AS "titles",
       String_Agg (title, ', ') AS "List of titles"
  FROM
    (SELECT au.au_id, title.title,
            Concat (au.au_fname, ' ', au.au_lname) AS Author, title.title_id
       FROM
       authors au
         INNER JOIN titleauthor ta
           ON au.au_id = ta.au_id
         INNER JOIN titles title
           ON ta.title_id = title.title_id) f
  GROUP BY
  f.Author, f.au_id
  ORDER BY f.Author;

Go

--Retrieve all co-authored titles and a list of their respective authors:
SELECT title, DatePart (YEAR, title.pubdate) AS "year published",
       String_Agg (Concat (au.au_fname, ' ', au.au_lname), ', ') AS "Author(s)",
       title.title_id
  FROM
  titles title
    INNER JOIN titleauthor ta
      ON ta.title_id = title.title_id
    INNER JOIN authors au
      ON au.au_id = ta.au_id
  GROUP BY
  title.title_id, title.title, title.pubdate
  HAVING Count (*) > 1;
Go
--Retrieve all single-authored titles and a list of their author:
SELECT title, DatePart (YEAR, title.pubdate) AS "year published",
       String_Agg (Concat (au.au_fname, ' ', au.au_lname), ', ') AS "Author(s)",
       title.title_id
  FROM
  titles title
    INNER JOIN titleauthor ta
      ON ta.title_id = title.title_id
    INNER JOIN authors au
      ON au.au_id = ta.au_id
  GROUP BY
  title.title_id, title.title, title.pubdate
  HAVING Count (*) = 1;
GO
--list of every author and every publication they either wrote or co-wrote, listing the authors
SELECT title, "Author(s)" AS "by...", "year published"
  FROM
    (SELECT title, DatePart (YEAR, title.pubdate) AS "year published",
            String_Agg (Concat (au.au_fname, ' ', au.au_lname), ', ') AS "Author(s)",
            title.title_id, Count (*) AS No_Authors
       FROM
       titles title
         INNER JOIN titleauthor ta
           ON ta.title_id = title.title_id
         INNER JOIN authors au
           ON au.au_id = ta.au_id
       GROUP BY
       title.title_id, title.title, title.pubdate) f
    INNER JOIN titleauthor ta
      ON ta.title_id = f.title_id
    INNER JOIN authors au
      ON au.au_id = ta.au_id;


go
--Find the top 5 best-selling titles along with their sales figures:
SELECT TOP 5 title.title_id, title.title, Sum (sale.qty) AS total_sales
  FROM  titles title
    INNER JOIN sales sale
      ON title.title_id = sale.title_id
  GROUP BY
  title.title_id, title.title
  ORDER BY total_sales DESC;
-- LIMIT 5;

GO
--Retrieve all publishers and the average price of their titles:
SELECT pub.pub_id, pub.pub_name, Avg (title.price) AS average_price,
       Count (*) AS "No. Titles"
  FROM publishers pub
    INNER JOIN titles title
      ON pub.pub_id = title.pub_id
  GROUP BY
  pub.pub_id, pub.pub_name;

  go
--Find the authors who have not published any titles:
SELECT au.au_id, au.au_fname, au.au_lname
  FROM authors au
    LEFT JOIN titleauthor ta
      ON au.au_id = ta.au_id
  WHERE ta.title_id IS NULL;

  Go
--Retrieve all employees and their respective job titles:
SELECT emp.emp_id, emp.fname, emp.lname, jobs.job_desc
  FROM dbo.employee emp
    INNER JOIN jobs
      ON emp.job_id = jobs.job_id;
Go
-- Find the total sales for each store:
SELECT sto.stor_id, sto.stor_name, Sum (sale.qty) AS total_sales
  FROM stores sto
    INNER JOIN sales sale
      ON sto.stor_id = sale.stor_id
  GROUP BY
  sto.stor_id, sto.stor_name;
Go
--Retrieve all titles and their corresponding royalty schedules:
SELECT title.title_id, title.title, rs.royalty
  FROM titles title
    INNER JOIN roysched rs
      ON title.title_id = rs.title_id;
Go
-- Find the authors who have the highest total sales:
SELECT TOP 20 au.au_id, au.au_fname, au.au_lname, Sum (sale.qty) AS total_sales
  FROM authors au
    INNER JOIN titleauthor ta
      ON au.au_id = ta.au_id
    INNER JOIN sales sale
      ON ta.title_id = sale.title_id
  GROUP BY
  au.au_id, au.au_fname, au.au_lname
  ORDER BY total_sales DESC;
Go
-- Retrieve all jobs and the number of employees in each job category:
SELECT jobs.job_id, jobs.job_desc, Count (emp.emp_id) AS employee_count
  FROM jobs
    LEFT JOIN employee emp
      ON jobs.job_id = emp.job_id
  GROUP BY
  jobs.job_id, jobs.job_desc;
Go
--Windowing Function: Calculate the running total sales for each title:
SELECT sales.qty AS Quantity_sold, sales.title_id, title,
       Sum (sales.qty) OVER (
			PARTITION BY titles.title_id ORDER BY ord_date
			) AS running_total
  FROM
  dbo.sales
    INNER JOIN dbo.titles
      ON titles.title_id = sales.title_id;
Go
/* This query uses the SUM windowing function to calculate the running total sales 
(running_total) for each title (title_id). The PARTITION BY clause divides the data 
by the title_id, and the ORDER BY clause specifies the order of rows within each
partition. */

--Common Table Expression (CTE): Retrieve all authors along with the total sales of their books:
WITH author_sales
AS (SELECT au.au_id, au.au_fname, au.au_lname, Sum (sale.qty) AS total_sales
      FROM
      authors au
        JOIN titleauthor ta
          ON au.au_id = ta.au_id
        JOIN sales sale
          ON ta.title_id = sale.title_id
      GROUP BY
      au.au_id, au.au_fname, au.au_lname)
  SELECT au_id, au_fname, au_lname, total_sales FROM author_sales;
Go
/* This query uses a CTE named author_sales to calculate the total sales (total_sales)
for each author. The CTE is then used in the main query to retrieve the author
information along with the total sales. */

-- Table Function: Retrieve the top-selling titles along with the average sales quantity per month:

/* number of books sold by book store */
SELECT Sum(qty) AS "quantity sold", Coalesce(stor_name, '(Direct Sales)') AS Store_Name
  FROM
  dbo.sales
    INNER JOIN dbo.publications
      ON publications.Publication_id = sales.title_id
    INNER JOIN dbo.stores
      ON stores.stor_id = sales.stor_id
	GROUP BY stor_name
GO
 
/* number of books sold by book store */
SELECT Sum(qty) AS "quantity sold", Coalesce(stor_name, '(Direct Sales)') AS Store_Name
  FROM
  dbo.sales
    INNER JOIN dbo.publications
      ON publications.Publication_id = sales.title_id
    INNER JOIN dbo.stores
      ON stores.stor_id = sales.stor_id
	GROUP BY stor_name
  UNION ALL 
SELECT Sum(qty), '--Total----'
  FROM
  dbo.sales

GO

-- The number OF orders for each title FROM each company
SELECT Sum(qty) AS Quantity, Title, Coalesce(stor_name, 'Direct Order') AS Bookshop
  FROM
  dbo.sales
    INNER JOIN dbo.publications
      ON publications.Publication_id = sales.title_id
    INNER JOIN dbo.stores
      ON stores.stor_id = sales.stor_id
GROUP BY Title, Stor_name;

-- The number OF orders of each title, and a list of who bought them FROM each company
SELECT Sum(qty) AS Quantity, title, String_Agg(stor_name,', ')AS Bookshops
  FROM
  dbo.sales
    INNER JOIN dbo.publications
      ON publications.Publication_id = sales.title_id
    INNER JOIN dbo.stores
      ON stores.stor_id = sales.stor_id
GROUP BY Title;

GO

-- This query calculates the average price of books by type using a window function.
SELECT title_id, title, price,
       AVG(price) OVER (PARTITION BY type) AS avg_price_by_type
FROM titles;
 
Go
--This query calculates the rank of each book based on its price using a window function. 
SELECT title_id, title, price,
       RANK() OVER (ORDER BY price DESC) AS price_rank
FROM titles;

Go
/* This finds the top 5 authors with the highest total sales, retrieves the titles
they have written, and includes the average sales quantity for each title. */
WITH top_authors
AS (SELECT TOP 5 au.au_id, au.au_fname, au.au_lname,
                 SUM (sale.qty) AS total_sales
      FROM
      authors au
        JOIN titleauthor ta
          ON au.au_id = ta.au_id
        JOIN sales sale
          ON ta.title_id = sale.title_id
      GROUP BY
      au.au_id, au.au_fname, au.au_lname
      ORDER BY total_sales DESC), avg_sales
AS (SELECT title_id, AVG (qty) AS avg_qty FROM sales GROUP BY title_id)
  SELECT ta.au_id, ta.au_fname, ta.au_lname, t.title_id, t.title, t.price,
         s.avg_qty
    FROM
    top_authors ta
      JOIN titleauthor ta2
        ON ta.au_id = ta2.au_id
      JOIN titles t
        ON ta2.title_id = t.title_id
      JOIN avg_sales s
        ON t.title_id = s.title_id;
go