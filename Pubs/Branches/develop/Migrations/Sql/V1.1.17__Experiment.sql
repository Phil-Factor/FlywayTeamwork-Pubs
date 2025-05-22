/* Arrange */
drop view if exists dbo.Book_Purchases_By_Date;
drop view if exists dbo.TitlesTopicsAuthorsAndEditions;
drop view if exists dbo.SalesByMonthAndYear;
drop function if exists dbo.PublishersEmployees;
drop function if exists dbo.calculate_monthly_sales;
drop function if exists dbo.TheYear;
GO

go
CREATE  VIEW dbo.SalesByMonthAndYear
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
SELECT  Datepart(YEAR,ord_date) AS "Date",
	Sum(CASE WHEN Datepart(month,ord_date) =1 THEN qty ELSE 0  END) AS Jan,
	Sum(CASE WHEN Datepart(month,ord_date) =2 THEN qty ELSE 0  END) AS Feb,
	Sum(CASE WHEN Datepart(month,ord_date) =3 THEN qty ELSE 0  END) AS Mar,
	Sum(CASE WHEN Datepart(month,ord_date) =4 THEN qty ELSE 0  END) AS Apr,
	Sum(CASE WHEN Datepart(month,ord_date) =5 THEN qty ELSE 0  END) AS May,
	Sum(CASE WHEN Datepart(month,ord_date) =6 THEN qty ELSE 0  END) AS Jun,
	Sum(CASE WHEN Datepart(month,ord_date) =7 THEN qty ELSE 0  END) AS Jul,
	Sum(CASE WHEN Datepart(month,ord_date) =8 THEN qty ELSE 0  END) AS Aug,
	Sum(CASE WHEN Datepart(month,ord_date) =9 THEN qty ELSE 0  END) AS Sep,
	Sum(CASE WHEN Datepart(month,ord_date) =10 THEN qty ELSE 0 END) AS Oct,
	Sum(CASE WHEN Datepart(month,ord_date) =11 THEN qty ELSE 0 END) AS Nov,
	Sum(CASE WHEN Datepart(month,ord_date) =12 THEN qty ELSE 0 END) AS Dec,
	Sum( qty) AS Total
  FROM
  dbo.sales
GROUP BY Datepart(YEAR,ord_date);

GO
CREATE  FUNCTION dbo.Calculate_Monthly_Sales
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
   - SELECT  title, F.*
		FROM titles 
		OUTER apply dbo.Calculate_Monthly_Sales(title_id,'2000','2023') F
		where titles.title like '%historical%'

  
**/
(
    @Title_id varchar(6)='%',
    @StartYear char(4)='2000',
	@EndYear char(4)= null
)
RETURNS @returntable TABLE 
(Date CHAR(4),
Jan int, Feb  int, Mar  int, Apr int, May int, Jun int,
Jul int, Aug  int, Sep  int, Oct int, Nov int, Dec int,
Total int
)
AS
BEGIN
SELECT @Endyear=Coalesce(@EndYear,DateName(YEAR,GETDATE()));
INSERT INTO @returntable
SELECT  DateName(YEAR,ord_date) AS "Date",
	Sum(CASE WHEN Datepart(Month,ord_date) =1 THEN qty ELSE 0  END) AS 'Jan',
	Sum(CASE WHEN Datepart(Month,ord_date) =2 THEN qty ELSE 0  END) AS 'Feb',
	Sum(CASE WHEN Datepart(Month,ord_date) =3 THEN qty ELSE 0  END) AS 'Mar',
	Sum(CASE WHEN Datepart(Month,ord_date) =4 THEN qty ELSE 0  END) AS 'Apr',
	Sum(CASE WHEN Datepart(Month,ord_date) =5 THEN qty ELSE 0  END) AS 'May',
	Sum(CASE WHEN Datepart(Month,ord_date) =6 THEN qty ELSE 0  END) AS 'Jun',
	Sum(CASE WHEN Datepart(Month,ord_date) =7 THEN qty ELSE 0  END) AS 'Jul',
	Sum(CASE WHEN Datepart(Month,ord_date) =8 THEN qty ELSE 0  END) AS 'Aug',
	Sum(CASE WHEN Datepart(Month,ord_date) =9 THEN qty ELSE 0  END) AS 'Sep',
	Sum(CASE WHEN Datepart(Month,ord_date) =10 THEN qty ELSE 0 END) AS 'Oct',
	Sum(CASE WHEN Datepart(Month,ord_date) =11 THEN qty ELSE 0 END) AS 'Nov',
	Sum(CASE WHEN Datepart(Month,ord_date) =12 THEN qty ELSE 0 END) AS 'Dec',
	Sum( qty) AS 'Total'
  FROM
  dbo.sales
  WHERE title_id LIKE @Title_id
  AND Datepart(Year,ord_date) BETWEEN  @StartYear AND @Endyear
GROUP BY DateName(YEAR,ord_date);
RETURN 
END;
Go
/*
In this example, dbo.Calculate_Monthly_Sales() 
is atable function that calculates the average sales quantity per month for 
the title and range specified. 
SELECT  title, F.*
		FROM titles 
		OUTER apply dbo.Calculate_Monthly_Sales(title_id,'2000','2023') F
		where titles.title like '%historical%'
*/

go
CREATE  FUNCTION dbo.TheYear( @TheDateTime DATETIME)

RETURNS CHAR(4)
AS
BEGIN
    RETURN DateName(YEAR,@TheDateTime)
END;
go

CREATE  VIEW dbo.TitlesTopicsAuthorsAndEditions
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
go



CREATE  FUNCTION dbo.PublishersEmployees
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
Returns: >
  
**/
(
    @company varchar(30) --the name of the publishing company or '_' for all.
)
RETURNS TABLE AS RETURN
(
SELECT fname
       + CASE WHEN minit = '' THEN ' ' ELSE COALESCE (' ' + minit + ' ', ' ') END
       + lname AS NAME, job_desc, pub_name, person.person_id
  FROM
  employee
    INNER JOIN jobs
      ON jobs.job_id = employee.job_id
    INNER JOIN dbo.publishers
      ON publishers.pub_id = employee.pub_id
	INNER JOIN people.person
	ON person.LegacyIdentifier='em-'+employee.emp_id
	WHERE pub_name LIKE '%'+@company+'%'
);

/*
Each order, when it happened, how many of each title, 
The book store and the publisher
*/
go
CREATE VIEW Book_Purchases_By_Date AS 
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
SELECT ord_num, CONVERT(CHAR(11),ord_date,113) AS date , qty,  title,
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
GO


/* Teardown 
drop view if exists dbo.Book_Purchases_By_Date; --drop the Book_Purchases_By_Date view
drop view if exists dbo.TitlesTopicsAuthorsAndEditions;--drop the TitlesTopicsAuthorsAndEditions view
drop view if exists dbo.SalesByMonthAndYear;--drop the SalesByMonthAndYear view
drop function if exists dbo.PublishersEmployees;--drop the PublishersEmployees function
drop function if exists dbo.calculate_monthly_sales;--drop the calculate_monthly_sales function
drop function if exists dbo.TheYear;--drop the TheYear function
Go
*/