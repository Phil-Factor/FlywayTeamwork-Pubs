/* Arrange */
drop view if exists dbo.Book_Purchases_By_Date;
drop view if exists dbo.TitlesTopicsAuthorsAndEditions;
drop view if exists dbo.SalesByMonthAndYear;
drop function if exists dbo.PublishersEmployees;
drop function if exists dbo.calculate_monthly_sales;
drop function if exists dbo.TheYear;

CREATE VIEW dbo.SalesByMonthAndYear
/**
Summary: >
  This does a pivot table breaking down sales by month and year
Author: phil factor
Date: Tuesday, 6 June 2023
Database: Pubs
Examples:
   - Select * from SalesByMonthAndYear
   - Select * from SalesByMonthAndYear

  
**/
as
SELECT  Date_part('YEAR',ord_date) AS "Date",
	Sum(CASE WHEN Date_part('Month',ord_date) =1 THEN qty ELSE 0  END) AS Jan,
	Sum(CASE WHEN Date_part('Month',ord_date) =2 THEN qty ELSE 0  END) AS Feb,
	Sum(CASE WHEN Date_part('Month',ord_date) =3 THEN qty ELSE 0  END) AS Mar,
	Sum(CASE WHEN Date_part('Month',ord_date) =4 THEN qty ELSE 0  END) AS Apr,
	Sum(CASE WHEN Date_part('Month',ord_date) =5 THEN qty ELSE 0  END) AS May,
	Sum(CASE WHEN Date_part('Month',ord_date) =6 THEN qty ELSE 0  END) AS Jun,
	Sum(CASE WHEN Date_part('Month',ord_date) =7 THEN qty ELSE 0  END) AS Jul,
	Sum(CASE WHEN Date_part('Month',ord_date) =8 THEN qty ELSE 0  END) AS Aug,
	Sum(CASE WHEN Date_part('Month',ord_date) =9 THEN qty ELSE 0  END) AS Sep,
	Sum(CASE WHEN Date_part('Month',ord_date) =10 THEN qty ELSE 0 END) AS Oct,
	Sum(CASE WHEN Date_part('Month',ord_date) =11 THEN qty ELSE 0 END) AS Nov,
	Sum(CASE WHEN Date_part('Month',ord_date) =12 THEN qty ELSE 0 END) AS Dec,
	Sum( qty) AS Total
  FROM
  dbo.sales
GROUP BY Date_part('YEAR',ord_date);


CREATE OR REPLACE FUNCTION dbo.calculate_monthly_sales
/**
Summary: >
  This gives the monthly breakdown 
  for all titles or a particular title (wildcard)
  between two years or all if you leave out the
  parameter
Author: phil factor
Date: Tuesday, 6 June 2023
Database: Pubs
Examples:
   - Select * from dbo.Calculate_Monthly_Sales('%','2000','2023')

  
**/
(
    title_id varchar(6) = '%',
    start_year char(4) = '2000',
    end_year char(4) = null
)
RETURNS TABLE (
    "Date" CHAR(4),
    Jan INT,
    Feb INT,
    Mar INT,
    Apr INT,
    May INT,
    Jun INT,
    Jul INT,
    Aug INT,
    Sep INT,
    Oct INT,
    Nov INT,
    "Dec" INT,
    Total INT
)
AS
'
BEGIN
    IF end_year IS NULL THEN
        end_year := to_char(current_date, ''YYYY'');
    END IF;

    RETURN QUERY
    SELECT
        to_char(ord_date, ''YYYY'') AS "Date",
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 1 THEN qty ELSE 0 END) AS Jan,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 2 THEN qty ELSE 0 END) AS Feb,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 3 THEN qty ELSE 0 END) AS Mar,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 4 THEN qty ELSE 0 END) AS Apr,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 5 THEN qty ELSE 0 END) AS May,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 6 THEN qty ELSE 0 END) AS Jun,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 7 THEN qty ELSE 0 END) AS Jul,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 8 THEN qty ELSE 0 END) AS Aug,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 9 THEN qty ELSE 0 END) AS Sep,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 10 THEN qty ELSE 0 END) AS Oct,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 11 THEN qty ELSE 0 END) AS Nov,
        SUM(CASE WHEN extract(MONTH FROM ord_date) = 12 THEN qty ELSE 0 END) AS "Dec",
        SUM(qty) AS Total
    FROM dbo.sales
    WHERE title_id LIKE title_id
        AND extract(YEAR FROM ord_date) BETWEEN start_year AND end_year
    GROUP BY to_char(ord_date, ''YYYY'');

END;
'
LANGUAGE plpgsql;



CREATE or replace FUNCTION dbo.TheYear( TheDateTime DATE)
RETURNS CHAR(4)
AS
'
BEGIN
    RETURN Date_part(''YEAR'',TheDateTime);
END;
'
LANGUAGE plpgsql;


CREATE VIEW dbo.TitlesTopicsAuthorsAndEditions
/**
Summary: >
  This is a view that lists all the authors, 
  editions and tages for titles
Author: PhilFactor
Date: Thursday, 25 May 2023
Database: Pubs
Examples:
   - Select * from dbo.TitlesTopicsAuthorsAndEditions
     where title like '%Pre-Raphaelite%'
   - Select "Author(s)" from dbo.TitlesTopicsAuthorsAndEditions
	 
Returns: >
	Title, Topic(s), Author(s), Editions(s)
**/
AS
  SELECT title, F.Publication_id AS code,
         Coalesce (authors, '') AS "Author(s)",
         Coalesce (topics, '') AS "Topic(s)",
         Coalesce (Editions, '') AS "Edition(s)"
    FROM
      (SELECT publications.Publication_id, Max (publications.title) AS title,
              String_Agg (Concat(au_fname ,' ', au_lname), ', ') AS "authors"
         FROM
         dbo.publications
           INNER JOIN dbo.titleauthor
             ON titleauthor.title_id = publications.Publication_id
           INNER JOIN dbo.authors
             ON authors.au_id = titleauthor.au_id
         GROUP BY publications.Publication_id) F
      LEFT OUTER JOIN
        (SELECT TagTitle.title_id AS publication_id,
                String_Agg (TagName.Tag, ', ') AS topics
           FROM
           dbo.TagName
             INNER JOIN dbo.TagTitle
               ON TagName.TagName_ID = TagTitle.TagName_ID
           GROUP BY TagTitle.title_id) g
        ON F.Publication_id = g.publication_id
      LEFT OUTER JOIN
        (SELECT editions.publication_id,
                String_Agg (
                  concat(editions.Publication_type, '(',dbo.TheYear(editions.EditionDate),')'),
                  ', ') AS Editions
           FROM dbo.editions
           GROUP BY editions.publication_id) H
        ON H.publication_id = F.Publication_id;




create or replace function dbo.PublishersEmployees
/**
Summary: >
  This is an in-line table function that you can use to select the
  employees of a particular company or group. It passes back the 
  person key from the people schema, so you can add addresses, emails
  phone numbers and so on.
Author: philfactor
Date: Friday, 26 May 2023
Database: Pubs
Examples:
   - Select * from dbo.PublishersEmployees('_')
   - 
     SELECT NAME, Job_Desc, pub_name,
       STRING_AGG (
         COALESCE (TypeOfPhone + ' - ' + DiallingNumber, 'None'), ', ') AS Contact_Numbers
     FROM
     dbo.PublishersEmployees ('Biblio')
       LEFT OUTER JOIN people.phone
         ON phone.person_id = PublishersEmployees.person_id
     WHERE phone.end_date IS NULL
     GROUP BY
     NAME, Job_Desc, Pub_name
     ORDER BY pub_name;

  
**/
(
    company varchar(30) --the name of the publishing company or '_' for all.
)
RETURNS TABLE (NAME varchar(100), job_desc varchar(100),
   pub_name varchar(100), person_id int)
AS
'
begin
SELECT fname
       + CASE WHEN minit = '''' THEN '' '' ELSE COALESCE ('' '' + minit + '' '', '' '') END
       + lname AS NAME, job_desc, pub_name, person.person_id
  FROM
  employee
    INNER JOIN dbo.jobs
      ON jobs.job_id = employee.job_id
    INNER JOIN dbo.publishers
      ON publishers.pub_id = employee.pub_id
	INNER JOIN people.person
	ON person.LegacyIdentifier=''em-''+employee.emp_id
	WHERE pub_name LIKE ''%''+company+''%'';

END;
'
LANGUAGE plpgsql;

/* Act */


  /*Retrieve all titles along with the number of authors for each title;*/
SELECT title.title_id, title.title, Count (*) AS author_count
  FROM
  dbo.titles title
    LEFT JOIN dbo.titleauthor ta
      ON title.title_id = ta.title_id
  GROUP BY
  title.title_id, title.title;


 --simply listing all titles, authors firstnames, surnames , and title_id 
 --a title can have several authors

SELECT title.title, au.au_fname, au.au_lname, title.title_id
  FROM
  dbo.authors au
    INNER JOIN dbo.titleauthor ta
      ON au.au_id = ta.au_id
    INNER JOIN dbo.titles title
      ON ta.title_id = title.title_id;


 --Retrieve all authors and their respective titles:
SELECT au.au_id, title.title,
       Concat (au.au_fname, ' ', au.au_lname) AS Author, title.title_id
  FROM
  dbo.authors au
    INNER JOIN dbo.titleauthor ta
      ON au.au_id = ta.au_id
    INNER JOIN dbo.titles title
      ON ta.title_id = title.title_id;

 -- All the books with the maximum number of co-authors
SELECT title.title_id, title.title, String_Agg(Concat (au.au_fname, ' ', au.au_lname), ', ')
   FROM
       dbo.authors au
         INNER JOIN dbo.titleauthor ta
           ON au.au_id = ta.au_id
         INNER JOIN dbo.titles title
           ON ta.title_id = title.title_id		  
  GROUP BY  title,title.title_id
  HAVING Count(au.au_id) =
(SELECT Max(authorcount) AS Max_Co_authors FROM 
	(SELECT title.title_id, Count (*) AS authorCount
		FROM dbo.titles title
			LEFT JOIN dbo.titleauthor ta
			  ON title.title_id = ta.title_id
		  GROUP BY
		  title.title_id)g)
ORDER BY title.title;


 --provide a list of authors, the number of titles, and a list of titles
SELECT f.Author AS "The Author", Count (title) AS "titles",
       String_Agg (title, ', ') AS "List of titles"
  FROM
    (SELECT au.au_id, title.title,
            Concat (au.au_fname, ' ', au.au_lname) AS Author, title.title_id
       FROM
       dbo.authors au
         INNER JOIN dbo.titleauthor ta
           ON au.au_id = ta.au_id
         INNER JOIN dbo.titles title
           ON ta.title_id = title.title_id) f
  GROUP BY
  f.Author, f.au_id
  ORDER BY f.Author;

/* Date_Part ('YEAR', title.pubdate) not Date_Part ('YEAR', title.pubdate)*/

 --Retrieve all co-authored titles and a list of their respective authors:
SELECT title, Date_Part ('YEAR', title.pubdate) AS "year published",
       String_Agg (Concat (au.au_fname, ' ', au.au_lname), ', ') AS "Author(s)",
       title.title_id
  FROM
  dbo.titles title
    INNER JOIN dbo.titleauthor ta
      ON ta.title_id = title.title_id
    INNER JOIN dbo.authors au
      ON au.au_id = ta.au_id
  GROUP BY
  title.title_id, title.title, title.pubdate
  HAVING Count (*) > 1;

 --Retrieve all single-authored titles and a list of their author:
SELECT title, Date_Part ('YEAR', title.pubdate)  AS "year published",
       String_Agg (Concat (au.au_fname, ' ', au.au_lname), ', ') AS "Author(s)",
       title.title_id
  FROM
  dbo.titles title
    INNER JOIN dbo.titleauthor ta
      ON ta.title_id = title.title_id
    INNER JOIN dbo.authors au
      ON au.au_id = ta.au_id
  GROUP BY
  title.title_id, title.title, title.pubdate
  HAVING Count (*) = 1;

 --list of every author and every publication they either wrote or co-wrote, listing the authors
SELECT title, "Author(s)" AS "by...", "year published"
  FROM
    (SELECT title, Date_Part ('YEAR', title.pubdate) AS "year published",
            String_Agg (Concat (au.au_fname, ' ', au.au_lname), ', ') AS "Author(s)",
            title.title_id, Count (*) AS No_Authors
       FROM
       dbo.titles title
         INNER JOIN dbo.titleauthor ta
           ON ta.title_id = title.title_id
         INNER JOIN dbo.authors au
           ON au.au_id = ta.au_id
       GROUP BY
       title.title_id, title.title, title.pubdate) f
    INNER JOIN dbo.titleauthor ta
      ON ta.title_id = f.title_id
    INNER JOIN dbo.authors au
      ON au.au_id = ta.au_id;



 --Find the top 5 best-selling titles along with their sales figures:
SELECT title.title_id, title.title, Sum (sale.qty) AS total_sales
  FROM  dbo.titles title
    INNER JOIN dbo.Sales sale
      ON title.title_id = sale.title_id
  GROUP BY
  title.title_id, title.title
  ORDER BY total_sales DESC
 LIMIT 5;

 --Retrieve all publishers and the average price of their titles:
SELECT pub.pub_id, pub.pub_name, cast(Avg (title.price) as money) AS average_price,
       Count (*) AS "No. Titles"
  FROM dbo.publishers pub
    INNER JOIN dbo.titles title
      ON pub.pub_id = title.pub_id
  GROUP BY
  pub.pub_id, pub.pub_name;

 --Find the authors who have not published any titles:
SELECT au.au_id, au.au_fname, au.au_lname
  FROM dbo.authors au
    LEFT JOIN dbo.titleauthor ta
      ON au.au_id = ta.au_id
  WHERE ta.title_id IS NULL;

 --Retrieve all employees and their respective job titles:
SELECT emp.emp_id, emp.fname, emp.lname, jobs.job_desc
  FROM dbo.employee emp
    INNER JOIN dbo.jobs
      ON emp.job_id = jobs.job_id;

 -- Find the total sales for each store:
SELECT sto.stor_id, sto.stor_name, Sum (sale.qty) AS total_sales
  FROM dbo.stores sto
    INNER JOIN dbo.Sales sale
      ON sto.stor_id = sale.stor_id
  GROUP BY
  sto.stor_id, sto.stor_name;

 --Retrieve all titles and their corresponding royalty schedules:
SELECT title.title_id, title.title, rs.royalty
  FROM dbo.titles title
    INNER JOIN dbo.roysched rs
      ON title.title_id = rs.title_id;

 -- Find the authors who have the highest total sales:
SELECT au.au_id, au.au_fname, au.au_lname, Sum (sale.qty) AS total_sales
  FROM dbo.authors au
    INNER JOIN dbo.titleauthor ta
      ON au.au_id = ta.au_id
    INNER JOIN dbo.Sales sale
      ON ta.title_id = sale.title_id
  GROUP BY
  au.au_id, au.au_fname, au.au_lname
  ORDER BY total_sales DESC
  limit 20;

 -- Retrieve all jobs and the number of employees in each job category:
SELECT jobs.job_id, jobs.job_desc, Count (emp.emp_id) AS employee_count
  FROM dbo.jobs
    LEFT JOIN dbo.employee emp
      ON jobs.job_id = emp.job_id
  GROUP BY
  jobs.job_id, jobs.job_desc;

 --Windowing Function: Calculate the running total sales for each title:
SELECT sales.qty AS Quantity_sold, sales.title_id, title,
       Sum (sales.qty) OVER (
			PARTITION BY titles.title_id ORDER BY ord_date
			) AS running_total
  FROM
  dbo.sales
    INNER JOIN dbo.titles
      ON titles.title_id = sales.title_id;

/* This query uses the SUM windowing function to calculate the running total sales 
(running_total) for each title (title_id). The PARTITION BY clause divides the data 
by the title_id, and the ORDER BY clause specifies the order of rows within each
partition. */

 --Common Table Expression (CTE): Retrieve all authors along with the total sales of their books:
WITH author_sales
AS (SELECT au.au_id, au.au_fname, au.au_lname, Sum (sale.qty) AS total_sales
      FROM
      dbo.authors au
        JOIN dbo.titleauthor ta
          ON au.au_id = ta.au_id
        JOIN dbo.sales sale
          ON ta.title_id = sale.title_id
      GROUP BY
      au.au_id, au.au_fname, au.au_lname)
  SELECT au_id, au_fname, au_lname, total_sales FROM author_sales;

/* This query uses a CTE named author_sales to calculate the total sales (total_sales)
for each author. The CTE is then used in the main query to retrieve the author
information along with the total sales. */

 -- Table Function: Retrieve the top-selling titles along with the average sales quantity per month:




/*
In this example, dbo.Calculate_Monthly_Sales() 
is a table function that calculates the average sales quantity per month for 
the title and range specified. */
SELECT
    titles.title,
    F.nov
FROM dbo.titles
LEFT JOIN LATERAL dbo.calculate_monthly_sales(titles.title_id, cast ('2000' as char(4)), cast('2023'as char(4))) F ON true
WHERE titles.title LIKE '%historical%';

/*
Each order, when it happened, how many of each title, 
The book store and the publisher
*/

CREATE VIEW dbo.Book_Purchases_By_Date AS 
/**
Summary: >
  Each order, when it happened, how many of each title, 
  The book store and the publisher
Author: philfactor
Date: Tuesday, 6 June 2023
Database: Pubs
Examples:
   - Select * from Book_Purchases_By_Date
   - Select * from Book_Purchases_By_Date 
       where Book_store = 'Orchid Books'
	   order by convert(datetime,date)
**/
SELECT ord_num, TO_CHAR(NOW()::date, 'dd/mm/yyyy') AS date , qty,  title,
       Coalesce (stor_name, 'Direct order') AS Book_Store,
       Coalesce (pub_name, 'Unknown') AS publisher
  FROM
  dbo.sales
    INNER JOIN dbo.publications
      ON publications.Publication_id = sales.title_id
    LEFT OUTER JOIN dbo.stores
      ON stores.stor_id = sales.stor_id
    LEFT OUTER JOIN dbo.publishers
      ON publishers.pub_id = publications.pub_id;


/* number of books sold by book store */
SELECT Sum(qty) AS "quantity sold", Coalesce(stor_name, '(Direct Sales)') AS Store_Name
  FROM
  dbo.sales
    INNER JOIN dbo.publications
      ON publications.Publication_id = sales.title_id
    INNER JOIN dbo.stores
      ON stores.stor_id = sales.stor_id
	GROUP BY stor_name;

 
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
  dbo.sales;


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



 -- This query calculates the average price of books by type using a window function.
SELECT title_id, title, price,
       AVG(price) OVER (PARTITION BY type) AS avg_price_by_type
FROM dbo.titles;
 

 --This query calculates the rank of each book based on its price using a window function. 
SELECT title_id, title, price,
       RANK() OVER (ORDER BY price DESC) AS price_rank
FROM dbo.titles;


/* This finds the top 5 authors with the highest total sales, retrieves the titles
they have written, and includes the average sales quantity for each title. */
WITH top_authors
AS (SELECT au.au_id, au.au_fname, au.au_lname,
                 SUM (sale.qty) AS total_sales
      FROM
      dbo.authors au
        JOIN dbo.titleauthor ta
          ON au.au_id = ta.au_id
        JOIN dbo.sales sale
          ON ta.title_id = sale.title_id
      GROUP BY
      au.au_id, au.au_fname, au.au_lname
      ORDER BY total_sales DESC limit 5), avg_sales
AS (SELECT title_id, AVG (qty) AS avg_qty FROM dbo.sales GROUP BY title_id)
  SELECT ta.au_id, ta.au_fname, ta.au_lname, t.title_id, t.title, t.price,
         s.avg_qty
    FROM
    top_authors ta
      JOIN dbo.titleauthor ta2
        ON ta.au_id = ta2.au_id
      JOIN dbo.titles t
        ON ta2.title_id = t.title_id
      JOIN avg_sales s
        ON t.title_id = s.title_id;

/* Teardown*/

drop view if exists dbo.Book_Purchases_By_Date;
drop view if exists dbo.TitlesTopicsAuthorsAndEditions;
drop view if exists dbo.SalesByMonthAndYear;
drop function if exists dbo.PublishersEmployees;
drop function if exists dbo.calculate_monthly_sales;
drop function if exists dbo.TheYear;
