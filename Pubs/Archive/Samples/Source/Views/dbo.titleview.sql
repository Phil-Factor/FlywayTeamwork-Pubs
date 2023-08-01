SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[titleview]
AS
SELECT title, au_ord, au_lname, price, ytd_sales, pub_id
  FROM authors, titles, titleauthor
  WHERE authors.au_id = titleauthor.au_id
    AND titles.title_id = titleauthor.title_id;
GO
