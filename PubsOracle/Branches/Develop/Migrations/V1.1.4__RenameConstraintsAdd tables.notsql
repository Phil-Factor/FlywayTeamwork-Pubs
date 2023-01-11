-- ''Creating types'

CREATE DOMAIN dbo.Dollars as numeric (9, 2) NULL;
-- 'Altering dbo.employee'
ALTER TABLE dbo.employee ALTER COLUMN pub_id type char (8);
ALTER TABLE dbo.employee ALTER COLUMN pub_id  set NOT NULL;

-- ''Altering dbo.publishers'

ALTER TABLE dbo.publishers ALTER COLUMN pub_id type char (8);
ALTER TABLE dbo.publishers ALTER COLUMN pub_id set NOT NULL;

-- ''Altering dbo.pub_info'

ALTER TABLE dbo.pub_info ALTER COLUMN pub_id type char (8);
ALTER TABLE dbo.pub_info ALTER COLUMN pub_id set NOT NULL;

-- ''Altering dbo.titles'

drop view dbo.titleview;

ALTER TABLE dbo.titles ALTER COLUMN pub_id type char (8);

CREATE OR REPLACE VIEW dbo.titleview
AS 
Select title, au_ord, au_lname, price, ytd_sales, pub_id
from dbo.titleauthor  inner join dbo.titles
on titles.title_id = titleauthor.title_id
inner join dbo.authors
on dbo.authors.au_id = dbo.titleauthor.au_id;

-- ''Creating dbo.publications'
CREATE TABLE dbo.publications
(
Publication_id dbo.tid NOT NULL primary key,
title character varying (255) NOT NULL,
pub_id dbo.tid NULL,
notes character varying(4000) NULL,
pubdate date NOT NULL DEFAULT (current_date)
);

-- ''Creating dbo.editions'
CREATE TABLE dbo.editions
(
Edition_id int  NOT NULL GENERATED ALWAYS AS IDENTITY Primary Key,
publication_id dbo.tid NOT NULL,
Publication_type character varying (20) NOT NULL DEFAULT ('book'),
EditionDate date NOT NULL DEFAULT (current_date)
);

-- ''Creating dbo.prices'
CREATE TABLE dbo.prices
(
Price_id int  NOT NULL GENERATED ALWAYS AS IDENTITY Primary Key,
Edition_id int NULL,
price dbo.Dollars NULL,
advance dbo.Dollars NULL,
royalty int NULL,
ytd_sales int NULL,
PriceStartDate date NOT NULL DEFAULT (current_Date),
PriceEndDate date NULL
);




