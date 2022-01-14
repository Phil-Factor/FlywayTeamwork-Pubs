GO

INSERT INTO publications (Publication_id, title, pub_id, notes, pubdate)
  SELECT title_id, title, pub_id, notes, pubdate FROM Titles;

INSERT INTO editions (publication_id, Publication_type, EditionDate)
  SELECT title_id, 'book', pubdate FROM Titles;

INSERT INTO dbo.prices (Edition_id, price, advance, royalty, ytd_sales,
PriceStartDate, PriceEndDate)
  SELECT Edition_id, price, advance, royalty, ytd_sales, pubdate, NULL
    FROM Titles t
      INNER JOIN editions
        ON t.title_id = editions.publication_id;
go 

ALTER TABLE dbo.sales DROP
   CONSTRAINT FK_Sales_Title

ALTER TABLE dbo.sales ADD
   CONSTRAINT  FK_Sales_Title
       FOREIGN KEY (title_id)
      REFERENCES  dbo.publications (publication_id)
     ON DELETE CASCADE


ALTER TABLE dbo.titleauthor DROP
   CONSTRAINT FK__titleauth__title

ALTER TABLE dbo.titleauthor ADD
   CONSTRAINT  FK__titleauth__title
       FOREIGN KEY (title_id)
      REFERENCES  dbo.publications (publication_id)
     ON DELETE CASCADE

ALTER TABLE dbo.roysched DROP
   CONSTRAINT FK__roysched__title

ALTER TABLE dbo.roysched ADD
   CONSTRAINT  FK__roysched__title
       FOREIGN KEY (title_id)
      REFERENCES  dbo.publications (publication_id)
     ON DELETE CASCADE
/* the unique collection of types of book, with one primary tag, showing where
they should be displayed. No book can have more than one tag and should have at
least one.*/
CREATE TABLE TagName --
  (TagName_ID INT IDENTITY(1, 1) CONSTRAINT TagnameSurrogate PRIMARY KEY, 
     Tag NVARCHAR(80) NOT NULL CONSTRAINT Uniquetag UNIQUE);

GO
CREATE TABLE TagTitle
  /* relationship table allowing more than one tag for a publication */
  (
  TagTitle_ID INT IDENTITY(1, 1),
  title_id dbo.tid NOT NULL CONSTRAINT FKTitle_id REFERENCES dbo.publications
                                                    (publication_id),
  Is_Primary BIT NOT NULL CONSTRAINT NotPrimary DEFAULT 0,
  TagName_ID INT NOT NULL CONSTRAINT fkTagname --
                          REFERENCES dbo.TagName (TagName_ID),
  CONSTRAINT PK_TagNameTitle --
    PRIMARY KEY CLUSTERED (title_id ASC, TagName_ID) ON [PRIMARY]
  );

  INSERT INTO TagName (Tag) SELECT DISTINCT type FROM Titles;

INSERT INTO TagTitle (title_id,Is_Primary,TagName_ID)
  SELECT title_id, 1, TagName_ID FROM Titles 
    INNER JOIN TagName ON Titles.type = TagName.Tag;


DROP TABLE dbo.titles
--now done by publications
go
CREATE VIEW dbo.titles
/* this view replaces the old TITLES table and shows only those books that represent each publication and only the current price */
AS
SELECT publications.Publication_id AS title_id, publications.title,
  Tag AS [Type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate
  FROM publications
    INNER JOIN editions
      ON editions.publication_id = publications.Publication_id
     AND Publication_type = 'book'
    INNER JOIN prices
      ON prices.Edition_id = editions.Edition_id
    LEFT OUTER JOIN TagTitle
      ON TagTitle.title_id = publications.Publication_id
     AND TagTitle.Is_Primary = 1 --just the first, primary, tag
    LEFT OUTER JOIN dbo.TagName
      ON TagTitle.TagName_ID = TagName.TagName_ID
  WHERE prices.PriceEndDate IS NULL;

GO
IF Object_Id('[dbo].[PublishersByPublicationType]') IS NULL
    EXEC('CREATE View [dbo].[PublishersByPublicationType] AS Select ''nothing'' as first')
GO
alter VIEW [dbo].[PublishersByPublicationType] as
/* A view to provide the number of each type of publication produced
by each publisher*/
SELECT Coalesce(publishers.pub_name, '---All types') AS publisher,
Sum(CASE WHEN Editions.Publication_type = 'AudioBook' THEN 1 ELSE 0 END) AS 'AudioBook',
Sum(CASE WHEN Editions.Publication_type ='Book' THEN 1 ELSE 0 END) AS 'Book',
Sum(CASE WHEN Editions.Publication_type ='Calendar' THEN 1 ELSE 0 END) AS 'Calendar',
Sum(CASE WHEN Editions.Publication_type ='Ebook' THEN 1 ELSE 0 END) AS 'Ebook',
Sum(CASE WHEN Editions.Publication_type ='Hardback' THEN 1 ELSE 0 END) AS 'Hardback',
Sum(CASE WHEN Editions.Publication_type ='Map' THEN 1 ELSE 0 END) AS 'Map',
Sum(CASE WHEN Editions.Publication_type ='Paperback' THEN 1 ELSE 0 END) AS 'PaperBack',
Count(*) AS total
 FROM dbo.publishers
INNER JOIN dbo.publications
ON publications.pub_id = publishers.pub_id
INNER JOIN editions ON editions.publication_id = publications.Publication_id
INNER JOIN dbo.prices ON prices.Edition_id = editions.Edition_id
WHERE prices.PriceEndDate IS null 
GROUP BY publishers.pub_name
WITH ROLLUP
GO

IF Object_Id('[dbo].[TitlesAndEditionsByPublisher]') IS NULL
    EXEC('CREATE View [dbo].[TitlesAndEditionsByPublisher] AS Select ''nothing'' as first')
GO

PRINT 'Now at the traditional create procedure section ....';

GO
 
IF OBJECT_ID('byroyalty') IS NULL
    EXEC('CREATE PROCEDURE byroyalty AS SET NOCOUNT ON;')
GO
ALTER PROCEDURE byroyalty @percentage INT
AS
  BEGIN
    SELECT titleauthor.au_id
      FROM dbo.titleauthor AS titleauthor
      WHERE titleauthor.royaltyper = @percentage;
  END;
GO

IF OBJECT_ID('reptq1') IS NULL
    EXEC('CREATE PROCEDURE reptq1 AS SET NOCOUNT ON;')
GO
ALTER PROCEDURE reptq1
AS
  BEGIN
    SELECT CASE WHEN Grouping(publications.pub_id) = 1 
	         THEN 'ALL' ELSE publications.pub_id END AS pub_id,
      Avg(price) AS avg_price
      FROM dbo.publishers
        INNER JOIN dbo.publications
          ON publications.pub_id = publishers.pub_id
        INNER JOIN editions
          ON editions.publication_id = publications.Publication_id
        INNER JOIN dbo.prices
          ON prices.Edition_id = editions.Edition_id
      WHERE prices.PriceEndDate IS NULL
      GROUP BY publications.pub_id WITH ROLLUP
      ORDER BY publications.pub_id;
  END;
GO

IF OBJECT_ID('reptq2') IS NULL
    EXEC('CREATE PROCEDURE reptq2 AS SET NOCOUNT ON;')
GO
ALTER PROCEDURE dbo.reptq2
AS
  BEGIN
    SELECT CASE WHEN Grouping(TN.tag) = 1 THEN 'ALL' ELSE TN.Tag END AS type,
      CASE WHEN Grouping(titles.pub_id) = 1 THEN 'ALL' ELSE titles.pub_id END AS pub_id,
      Avg(titles.ytd_sales) AS avg_ytd_sales
      FROM dbo.titles AS titles
        INNER JOIN dbo.TagTitle AS TagTitle
          ON TagTitle.title_id = titles.title_id
        INNER JOIN dbo.TagName AS TN
          ON TN.TagName_ID = TagTitle.TagName_ID
      WHERE titles.pub_id IS NOT NULL AND TagTitle.Is_Primary = 1
      GROUP BY titles.pub_id, TN.Tag WITH ROLLUP;
  END;

GO

IF OBJECT_ID('reptq3') IS NULL
    EXEC('CREATE PROCEDURE reptq3 AS SET NOCOUNT ON;')
GO
ALTER PROCEDURE dbo.reptq3 @lolimit dbo.Dollars, @hilimit dbo.Dollars,
  @type CHAR(12)
AS
  BEGIN
    SELECT CASE WHEN Grouping(titles.pub_id) = 1 THEN 'ALL' ELSE titles.pub_id END AS pub_id,
      CASE WHEN Grouping(TN.tag) = 1 THEN 'ALL' ELSE TN.Tag END AS type,
      Count(titles.title_id) AS cnt
      FROM dbo.titles AS titles
        INNER JOIN dbo.TagTitle AS TagTitle
          ON TagTitle.title_id = titles.title_id
        INNER JOIN dbo.TagName AS TN
          ON TN.TagName_ID = TagTitle.TagName_ID
      WHERE titles.price > @lolimit
        AND TagTitle.Is_Primary = 1
        AND titles.price < @hilimit
        AND TN.Tag = @type
         OR TN.Tag LIKE '%cook%'
      GROUP BY titles.pub_id, TN.Tag WITH ROLLUP;
  END;
GO

