INSERT INTO publications (Publication_id, title, pub_id, notes, pubdate)
  SELECT title_id, title, pub_id, notes, pubdate FROM Titles;

INSERT INTO editions (publication_id, Publication_type, EditionDate)
  SELECT title_id, 'book', pubdate FROM Titles;

INSERT INTO prices (Edition_id, price, advance, royalty, ytd_sales,
PriceStartDate, PriceEndDate)
  SELECT Edition_id, price, advance, royalty, ytd_sales, pubdate, NULL
    FROM Titles t
      INNER JOIN editions
        ON t.title_id = editions.publication_id;

CREATE TABLE Newsales (
	stor_id char(4) NOT NULL,
	ord_num varchar(20) NOT NULL,
	ord_date varchar(50) NOT NULL,
	qty int NOT NULL,
	payterms varchar(12) NOT NULL,
	title_id dbo.tid NOT NULL REFERENCES  publications (publication_id),
	PRIMARY KEY (ord_num,stor_id,title_id),
	FOREIGN KEY (stor_id) REFERENCES stores (stor_id)

	);

INSERT INTO NewSales (stor_id, ord_num, title_id, ord_date, qty, payterms)
  SELECT stor_id, ord_num, title_id, ord_date, qty, payterms FROM sales;

DROP TABLE sales;
ALTER TABLE NewSales RENAME TO Sales;

DROP VIEW titleview;

CREATE TABLE Newtitleauthor (
	au_id varchar(11) NOT NULL,
	title_id dbo.tid NOT NULL,
	au_ord int,
	royaltyper int,
	FOREIGN KEY (au_id) REFERENCES authors (au_id),
   FOREIGN KEY (title_id) REFERENCES  publications (publication_id),
	PRIMARY KEY (au_id,title_id)
);



INSERT INTO NewTitleauthor(au_id, title_id, au_ord, royaltyper)
  SELECT au_id, title_id, au_ord, royaltyper FROM titleauthor; 
DROP TABLE titleauthor ;
ALTER TABLE Newtitleauthor  RENAME TO titleauthor;

CREATE TABLE Newroysched (
	title_id varchar(6) NOT NULL,
	lorange int,
	hirange int,
	royalty int,
	FOREIGN KEY (title_id) REFERENCES  publications (publication_id)
);

INSERT INTO Newroysched(title_id, lorange, hirange, royalty) 
SELECT title_id, lorange, hirange, royalty FROM roysched;
DROP TABLE roysched;
ALTER TABLE Newroysched  RENAME TO roysched;

/* the unique collection of types of book, with one primary tag, showing where
they should be displayed. No book can have more than one tag and should have at
least one.*/
CREATE TABLE TagName --
  (TagName_ID int  NOT NULL GENERATED ALWAYS AS IDENTITY Primary KEY, 
     Tag VARCHAR(80) NOT NULL UNIQUE);


CREATE TABLE TagTitle
  /* relationship table allowing more than one tag for a publication */
  (
  title_id  varchar(6) NOT NULL,
  Is_Primary int NOT NULL CONSTRAINT NotPrimary DEFAULT 0,
  TagName_ID INT NOT NULL,
	FOREIGN KEY (TagName_ID) REFERENCES TagName (TagName_ID),
   FOREIGN KEY (title_id) REFERENCES  publications (publication_id),
   PRIMARY KEY (title_id, TagName_ID)
  );

  INSERT INTO TagName (Tag) SELECT DISTINCT type FROM Titles;

INSERT INTO TagTitle (title_id,Is_Primary,TagName_ID)
  SELECT title_id, 1, TagName_ID FROM Titles 
    INNER JOIN TagName ON Titles.type = TagName.Tag;


DROP TABLE titles;
--now done by publications


CREATE VIEW titles
/* this view replaces the old TITLES table and shows only those books that represent each publication and only the current price */
AS
SELECT publications.Publication_id AS title_id, publications.title,
  Tag AS Type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate
  FROM publications
    INNER JOIN editions
      ON editions.publication_id = publications.Publication_id
     AND Publication_type = 'book'
    INNER JOIN prices
      ON prices.Edition_id = editions.Edition_id
    LEFT OUTER JOIN TagTitle
      ON TagTitle.title_id = publications.Publication_id
     AND TagTitle.Is_Primary = 1 --just the first, primary, tag
    LEFT OUTER JOIN TagName
      ON TagTitle.TagName_ID = TagName.TagName_ID
  WHERE prices.PriceEndDate IS NULL;

Create VIEW titleview
AS 
Select title, au_ord, au_lname, price, ytd_sales, pub_id
from titleauthor  inner join titles
on titles.title_id = titleauthor.title_id
inner join authors
on authors.au_id = titleauthor.au_id;



/*
create VIEW PublishersByPublicationType as
 A view to provide the number of each type of publication produced
by each publisher
SELECT Coalesce(publishers.pub_name, '---All types') AS publisher,
Sum(CASE WHEN Editions.Publication_type = 'AudioBook' THEN 1 ELSE 0 END) AS 'AudioBook',
Sum(CASE WHEN Editions.Publication_type ='Book' THEN 1 ELSE 0 END) AS 'Book',
Sum(CASE WHEN Editions.Publication_type ='Calendar' THEN 1 ELSE 0 END) AS 'Calendar',
Sum(CASE WHEN Editions.Publication_type ='Ebook' THEN 1 ELSE 0 END) AS 'Ebook',
Sum(CASE WHEN Editions.Publication_type ='Hardback' THEN 1 ELSE 0 END) AS 'Hardback',
Sum(CASE WHEN Editions.Publication_type ='Map' THEN 1 ELSE 0 END) AS 'Map',
Sum(CASE WHEN Editions.Publication_type ='Paperback' THEN 1 ELSE 0 END) AS 'PaperBack',
Count(*) AS total
 FROM publishers
INNER JOIN publications
ON publications.pub_id = publishers.pub_id
INNER JOIN editions ON editions.publication_id = publications.Publication_id
INNER JOIN prices ON prices.Edition_id = editions.Edition_id
WHERE prices.PriceEndDate IS null 
GROUP BY publishers.pub_name;
*/
	     