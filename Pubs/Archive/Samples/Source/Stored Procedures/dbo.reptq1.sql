SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[reptq1]
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
