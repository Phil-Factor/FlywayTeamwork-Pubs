/* this migration file creates a table of publication types and 
then stocks the editions and pricxes with a range of editions of 
the types we've defined 
it then alters the existing  dbo.TitlesAndEditionsByPublisher 
view  that lists Titles And Editions By Publisher, adding the 
list of editions*/

CREATE TABLE dbo.Publication_Types(
	Publication_Type national character varying (20) PRIMARY key
);
INSERT INTO dbo.Publication_Types(Publication_Type)
SELECT Type from (VALUES ('book'),('paperback'),('ebook'),('audiobook'))f(type);


ALTER TABLE dbo.editions 
/* the editions of the publication */
ADD  CONSTRAINT fk_Publication_Type FOREIGN KEY(publication_Type)
REFERENCES dbo.Publication_Types (Publication_Type);


COMMENT ON COLUMN dbo.Publication_Types.Publication_Type IS 'An edition can be one of several types';

INSERT INTO dbo.Editions (publication_id, Publication_Type, EditionDate)
  SELECT publication_id,
  		 'paperback' as publication_type,
                 (NOW() - interval '2 years') + (random() * (NOW()+'900 days' - NOW())) as Date
    from dbo.editions 
      LEFT OUTER JOIN dbo.Prices
        ON editions.Edition_id = Prices.Edition_id
       AND editions.publication_Type = 'paperback'
    WHERE prices.price_id IS NULL
    order by random()  limit 600;

INSERT INTO dbo.Editions (publication_id, Publication_Type, EditionDate)
 SELECT publication_id,
  		 'ebook' as publication_type,
  				(NOW() - interval '2 years') + (random() * (NOW()+'900 days' - NOW())) as Date
    from dbo.editions 
      LEFT OUTER JOIN dbo.Prices
        ON editions.Edition_id = Prices.Edition_id
       AND editions.publication_Type = 'paperback'
    WHERE prices.price_id IS NULL
    order by random()  limit 200;


INSERT INTO dbo.Editions (publication_id, Publication_Type, EditionDate)
SELECT publication_id,
  		 'audiobook' as publication_type,
                 (NOW() - interval '2 years') + (random() * (NOW()+'900 days' - NOW())) as Date
    from dbo.editions 
      LEFT OUTER JOIN dbo.Prices
        ON editions.Edition_id = Prices.Edition_id
       AND editions.publication_Type = 'paperback'
    WHERE prices.price_id IS NULL
    order by random()  limit 800;

/* make sure there is a price for every edition*/
INSERT INTO dbo.prices (Edition_id,price,Advance,Royalty, ytd_sales,PriceStartDate)
	SELECT editions.Edition_id, 
		Abs(Random() * (40 - 4.00 - 1))::NUMERIC::MONEY AS price,
		Abs(Random() * (1200 - 00.00 - 1))::NUMERIC::MONEY AS Advance,
		Abs(Random() * (60 - 00.00 - 1))::int AS Royalty,
		Abs(Random() * (3000 - 00.00 - 1))::int AS ytd_sales,
		Editiondate AS PriceStartDate FROM dbo.editions
	LEFT outer JOIN dbo.prices 
		ON editions.edition_id=prices.Edition_id
		WHERE price_id IS null;


DROP VIEW  IF EXISTS  dbo.TitlesAndEditionsByPublisher;

create VIEW dbo.TitlesAndEditionsByPublisher 
/* Titles And Editions By Publisher */
AS
/* A view to provide the number of each type of publication produced
Select * from [dbo].[TitlesAndEditionsByPublisher]
by each publisher*/
Select publishers.pub_name AS publisher, publications.title,
   string_agg(concat(editions.Publication_type,' ($', prices.price,')'),',' ) AS ListOfEditions
FROM dbo.editions
 INNER JOIN dbo.prices 
   ON prices.Edition_id = editions.Edition_id
INNER JOIN dbo.publications
   on publications.Publication_id  = Editions.Publication_id 
INNER JOIN dbo.publishers
   ON publications.pub_id = publishers.pub_id
WHERE prices.PriceEndDate IS NULL
group by publishers.pub_name,publications.title;




