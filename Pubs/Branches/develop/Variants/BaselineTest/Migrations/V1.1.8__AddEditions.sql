/* this migration file creates a table of publication types and 
then stocks the editions and pricxes with a range of editions of 
the types we've defined 
it then alters the existing  dbo.TitlesAndEditionsByPublisher 
view  that lists Titles And Editions By Publisher, adding the 
list of editions*/

CREATE TABLE [dbo].Publication_Types(
	Publication_Type [nvarchar](20) PRIMARY key
)
INSERT INTO dbo.Publication_Types(Publication_Type)
SELECT Type from (VALUES ('book'),('paperback'),('ebook'),('audiobook'))f(type)
ALTER TABLE [dbo].[editions]  WITH CHECK ADD  CONSTRAINT [fk_Publication_Type] FOREIGN KEY([publication_Type])
REFERENCES [dbo].[publication_Types] ([Publication_Type])

EXEC sys.sp_addextendedproperty @name=N'MS_Description', 
	@value=N'An edition can be one of several types' , 
	@level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Publication_Types'
GO

INSERT INTO dbo.Editions (publication_id, Publication_Type, EditionDate)
  SELECT TOP 600 publication_id, 'paperback',
                 DateAdd (
                   DAY,
                   Rand (Checksum (NewId ()))
                   * (1 + DateDiff (DAY, '2000-01-01', '2021-01-01')),
                   '2000-01-01')
    FROM dbo.editions
      LEFT OUTER JOIN dbo.Prices
        ON editions.Edition_id = Prices.Edition_id
       AND editions.publication_Type = 'paperback'
    WHERE prices.price_id IS NULL
    ORDER BY NewId ();

INSERT INTO dbo.Editions (publication_id, Publication_Type, EditionDate)
  SELECT TOP 200 publication_id, 'ebook',
                 DateAdd (
                   DAY,
                   Rand (Checksum (NewId ()))
                   * (1 + DateDiff (DAY, '2000-01-01', '2021-01-01')),
                   '2000-01-01')
    FROM dbo.editions
      LEFT OUTER JOIN Prices
        ON editions.Edition_id = Prices.Edition_id
       AND editions.publication_Type = 'ebook'
    WHERE prices.price_id IS NULL
    ORDER BY NewId ();

INSERT INTO dbo.Editions (publication_id, Publication_Type, EditionDate)
  SELECT TOP 800 publication_id, 'AudioBook',
                 DateAdd (
                   DAY,
                   Rand (Checksum (NewId ()))
                   * (1 + DateDiff (DAY, '2000-01-01', '2021-01-01')),
                   '2000-01-01')
    FROM dbo.editions
      LEFT OUTER JOIN dbo.Prices
        ON editions.Edition_id = Prices.Edition_id
       AND editions.publication_Type = 'Audiobook'
    WHERE prices.price_id IS NULL
    ORDER BY NewId ();
/* make sure there is a price for every edition*/
INSERT INTO dbo.prices (Edition_id,price,Advance,Royalty, ytd_sales,PriceStartDate)
	SELECT editions.Edition_id, 
		Abs(Checksum(NEWID()) % (120 - 30.00 - 1) + 30.00) AS price,
		Abs(Checksum(NEWID()) % (1200 - 0.00 - 1) + 0.00) AS Advance,
		Convert(INT,Abs(Checksum(NEWID()) % (60 - 0.00 - 1) + 0.00))AS Royalty,
		Convert(INT,Abs(Checksum(NEWID()) % (3000 - 0.00 - 1) + 0.00))AS ytd_sales,
		Editiondate AS PriceStartDate FROM editions
	LEFT outer JOIN prices 
		ON editions.edition_id=prices.Edition_id
		WHERE price_id IS null

GO
ALTER VIEW dbo.TitlesAndEditionsByPublisher (Publisher,Title,ListofEditions)
AS
/* A view to provide the number of each type of publication produced
Select * from [dbo].[TitlesAndEditionsByPublisher]
by each publisher*/

SELECT publishers.pub_name AS publisher, publications.title,
  Stuff(
         (
         SELECT ', ' + editions.Publication_type + ' ($' + Convert(VARCHAR(20), prices.price)
                + ')'
           FROM editions
             INNER JOIN dbo.prices 
               ON prices.Edition_id = editions.Edition_id
           WHERE prices.PriceEndDate IS NULL
             AND editions.publication_id = publications.Publication_id
         FOR XML PATH(''), TYPE
         ).value('.', 'nvarchar(max)'), 1, 2, '' ) AS ListOfEditions
  FROM dbo.publishers
    INNER JOIN dbo.publications
      ON publications.pub_id = publishers.pub_id;

GO
