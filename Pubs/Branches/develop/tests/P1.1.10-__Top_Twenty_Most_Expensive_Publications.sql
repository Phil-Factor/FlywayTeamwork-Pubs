/* Top twenty publications by price */
SELECT TOP 20 title, pub_name, editions.publication_Type, price
  FROM
  publications
    INNER JOIN publishers
      ON publishers.pub_id = publications.pub_id
    INNER JOIN editions
      ON editions.publication_id = publications.publication_id
    INNER JOIN prices
      ON prices.edition_id = editions.edition_id
  WHERE prices.priceenddate IS NULL
  ORDER BY price DESC;
