/* this migration file creates a table of publication types and 
then stocks the editions and pricxes with a range of editions of 
the types we've defined 
it then alters the existing  dbo.TitlesAndEditionsByPublisher 
view  that lists Titles And Editions By Publisher, adding the 
list of editions */



CREATE TABLE Publication_Types (
    Publication_Type VARCHAR(20) PRIMARY KEY
) COMMENT = 'This table contains types of publications such as books, paperbacks, ebooks, and audiobooks.';

INSERT INTO Publication_Types (Publication_Type)
SELECT 'book' UNION ALL
SELECT 'paperback' UNION ALL
SELECT 'ebook' UNION ALL
SELECT 'audiobook';

-- Alter the existing editions table to add the foreign key constraint
ALTER TABLE dbo.editions
ADD CONSTRAINT fk_Publication_Type
FOREIGN KEY (publication_Type)
REFERENCES Publication_Types (Publication_Type);

INSERT INTO dbo.editions (publication_id, publication_Type, EditionDate)
SELECT publication_id, 'paperback',
    DATE_ADD('2000-01-01', INTERVAL FLOOR(RAND() * DATEDIFF('2021-01-01', '2000-01-01')) DAY)
FROM dbo.editions
LEFT JOIN dbo.prices
    ON dbo.editions.Edition_id = dbo.prices.Edition_id
    AND dbo.editions.publication_Type = 'paperback'
WHERE dbo.prices.price_id IS NULL
ORDER BY RAND()
LIMIT 200;

INSERT INTO dbo.editions (publication_id, publication_Type, EditionDate)
SELECT publication_id, 'ebook',
    DATE_ADD('2000-01-01', INTERVAL FLOOR(RAND() * DATEDIFF('2021-01-01', '2000-01-01')) DAY)
FROM dbo.editions
LEFT JOIN dbo.prices
    ON dbo.editions.Edition_id = dbo.prices.Edition_id
    AND dbo.editions.publication_Type = 'ebook'
WHERE dbo.prices.price_id IS NULL
ORDER BY RAND()
LIMIT 200;


INSERT INTO dbo.editions (publication_id, publication_Type, EditionDate)
SELECT publication_id, 'audiobook',
    DATE_ADD('2000-01-01', INTERVAL FLOOR(RAND() * DATEDIFF('2021-01-01', '2000-01-01')) DAY)
FROM dbo.editions
LEFT JOIN dbo.prices
    ON dbo.editions.Edition_id = dbo.prices.Edition_id
    AND dbo.editions.publication_Type = 'audiobook'
WHERE dbo.prices.price_id IS NULL
ORDER BY RAND()
LIMIT 200;

-- Insert random price data for editions without a price
INSERT INTO prices (Edition_id, price, Advance, Royalty, ytd_sales, PriceStartDate)
SELECT editions.Edition_id, 
       ABS(FLOOR(RAND() * (120 - 30.00) + 30.00)) AS price,
       ABS(FLOOR(RAND() * (1200 - 0.00) + 0.00)) AS Advance,
       CAST(ABS(FLOOR(RAND() * (60 - 0.00) + 0.00)) AS UNSIGNED) AS Royalty,
       CAST(ABS(FLOOR(RAND() * (3000 - 0.00) + 0.00)) AS UNSIGNED) AS ytd_sales,
       Editiondate AS PriceStartDate 
FROM editions
LEFT JOIN prices 
    ON editions.Edition_id = prices.Edition_id
WHERE prices.price_id IS NULL;


CREATE OR REPLACE VIEW TitlesAndEditionsByPublisher AS
SELECT 
    publishers.pub_name AS publisher,
    publications.title,
    GROUP_CONCAT(CONCAT(editions.Publication_Type, ' ($', prices.price, ')') SEPARATOR ', ') AS ListOfEditions
FROM 
    publishers
INNER JOIN 
    publications ON publications.pub_id = publishers.pub_id
LEFT JOIN 
    editions ON editions.publication_id = publications.Publication_id
LEFT JOIN 
    prices ON prices.Edition_id = editions.Edition_id
WHERE 
    prices.PriceEndDate IS NULL
GROUP BY 
    publishers.pub_name, publications.title;
    
