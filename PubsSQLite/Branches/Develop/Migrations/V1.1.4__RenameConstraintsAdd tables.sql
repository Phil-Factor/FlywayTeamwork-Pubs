




Create VIEW titleview
AS 
Select title, au_ord, au_lname, price, ytd_sales, pub_id
from titleauthor  inner join titles
on titles.title_id = titleauthor.title_id
inner join authors
on authors.au_id = titleauthor.au_id;

-- ''Creating publications'
CREATE TABLE publications
(
Publication_id varchar(6) NOT NULL primary key,
title character varying (255) NOT NULL,
pub_id char (8) NULL,
notes character varying(4000) NULL,
pubdate datetime DEFAULT ( CURDATE() ) NOT NULL
);

-- ''Creating editions'
CREATE TABLE editions
(
Edition_id INTEGER PRIMARY KEY AUTOINCREMENT,
publication_id varchar(6) NOT NULL,
Publication_type character varying (20) NOT NULL DEFAULT ('book'),
EditionDate datetime DEFAULT ( CURDATE() ) NOT NULL
);

-- ''Creating prices'
CREATE TABLE prices
(
Price_id INTEGER PRIMARY KEY AUTOINCREMENT,
Edition_id int NULL,
price decimal(19,4) NULL,
advance decimal(19,4) NULL,
royalty int NULL,
ytd_sales int NULL,
PriceStartDate date NOT NULL DEFAULT (current_Date),
PriceEndDate date NULL
);






