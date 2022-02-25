-- 'Dropping foreign keys from dbo.sales'
ALTER TABLE dbo.sales DROP CONSTRAINT FK__sales__stor_id;
ALTER TABLE dbo.sales DROP CONSTRAINT FK__sales__title_id;
-- 'Dropping constraints from dbo.sales'
ALTER TABLE dbo.sales DROP CONSTRAINT UPKCL_sales;
-- 'Dropping constraints from dbo.authors'
ALTER TABLE dbo.authors ALTER COLUMN phone DROP DEFAULT; 
-- 'Dropping constraints from dbo.publishers'
ALTER TABLE dbo.publishers ALTER COLUMN  country DROP DEFAULT;
-- 'Dropping constraints from dbo.titles'
ALTER TABLE dbo.titles ALTER COLUMN type DROP DEFAULT;
-- 'Dropping index aunmind from dbo.authors'
DROP INDEX aunmind;

-- 'Dropping index titleind from dbo.titles'
DROP INDEX titleind;

-- 'Dropping index employee_ind from dbo.employee'
DROP INDEX employee_ind;

-- 'Altering dbo.stores'

ALTER TABLE dbo.stores ALTER COLUMN stor_name SET DATA TYPE character varying(80);
ALTER TABLE dbo.stores ALTER COLUMN stor_address SET DATA TYPE character varying(80);
ALTER TABLE dbo.stores ALTER COLUMN city SET DATA TYPE character varying(40);

-- 'Altering dbo.discounts'

ALTER TABLE dbo.discounts ADD
Discount_id int  NOT NULL GENERATED ALWAYS AS IDENTITY;

ALTER TABLE dbo.discounts ALTER COLUMN discounttype SET DATA TYPE character varying(80);
ALTER TABLE dbo.discounts ALTER COLUMN discounttype SET NOT NULL;

-- 'Creating primary key PK__discount__63D7679C0CEEA6FF on dbo.discounts'
ALTER TABLE dbo.discounts ADD PRIMARY KEY  (Discount_id);

CREATE INDEX pk_discounts_idx
    ON dbo.discounts  USING btree
    (Discount_id ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE dbo.discounts 
    CLUSTER ON pk_discounts_idx;

ALTER TABLE dbo.employee ALTER COLUMN fname SET DATA TYPE  character varying(40);
ALTER TABLE dbo.employee ALTER COLUMN fname SET NOT NULL;

ALTER TABLE dbo.employee ALTER COLUMN lname SET DATA TYPE character varying(60);
ALTER TABLE dbo.employee ALTER COLUMN lname SET NOT NULL;

-- 'Creating index employee_ind on dbo.employee'
CREATE INDEX employee_ind ON dbo.employee (lname, fname, minit);
ALTER TABLE dbo.employee 
    CLUSTER ON employee_ind;
-- 'Altering dbo.publishers'

ALTER TABLE dbo.publishers ALTER COLUMN pub_name SET DATA TYPE character varying(100);

ALTER TABLE dbo.publishers ALTER COLUMN city SET DATA TYPE character varying(100);

ALTER TABLE dbo.publishers ALTER COLUMN country SET DATA TYPE character varying(80);

Drop View dbo.titleview;

-- 'Altering dbo.titles'

ALTER TABLE dbo.titles ALTER COLUMN title SET DATA TYPE character varying(255);
ALTER TABLE  dbo.titles ALTER COLUMN title SET NOT NULL;

ALTER TABLE dbo.titles ALTER COLUMN type SET DATA TYPE character varying(80);
ALTER TABLE dbo.titles ALTER COLUMN type SET NOT NULL;

ALTER TABLE dbo.titles ALTER COLUMN notes SET DATA TYPE character varying(4000);

-- 'Creating index titleind on dbo.titles'
CREATE INDEX titleind ON dbo.titles (title);

-- 'Altering dbo.roysched'

ALTER TABLE dbo.roysched ADD
roysched_id int NOT NULL GENERATED ALWAYS AS IDENTITY;
ALTER TABLE dbo.roysched  ADD PRIMARY KEY  (roysched_id);

CREATE INDEX pk_roysched_id_idx
    ON dbo.roysched  USING btree
    (roysched_id  ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE dbo.roysched
    CLUSTER ON pk_roysched_id_idx;

-- 'Altering dbo.sales'

ALTER TABLE dbo.sales ALTER COLUMN ord_num SET DATA TYPE character varying(80);
ALTER TABLE dbo.sales ALTER COLUMN ord_num  SET NOT NULL;
ALTER TABLE dbo.sales ALTER COLUMN payterms SET DATA TYPE character varying(40) ;
ALTER TABLE dbo.sales ALTER COLUMN payterms SET NOT NULL;
-- 'Creating primary key UPKCL_sales on dbo.sales'
ALTER TABLE dbo.sales ADD CONSTRAINT UPKCL_sales PRIMARY KEY (stor_id, ord_num, title_id);

CREATE INDEX Store_ID_Ord_Titleidx
    ON dbo.sales USING btree
    (stor_id, ord_num, title_id)
    TABLESPACE pg_default;

ALTER TABLE dbo.sales 
    CLUSTER ON Store_ID_Ord_Titleidx;
-- 'Altering dbo.authors'

ALTER TABLE dbo.authors ALTER COLUMN au_lname SET DATA TYPE character varying(80);
ALTER TABLE dbo.authors ALTER COLUMN au_lname  SET NOT NULL;
ALTER TABLE dbo.authors ALTER COLUMN au_fname SET DATA TYPE character varying(80) ;
ALTER TABLE dbo.authors ALTER COLUMN au_fname  SET NOT NULL;
ALTER TABLE dbo.authors ALTER COLUMN phone SET DATA TYPE character varying(40);
ALTER TABLE dbo.authors ALTER COLUMN phone  SET NOT NULL;
ALTER TABLE dbo.authors ALTER COLUMN address SET DATA TYPE character varying(80);
ALTER TABLE dbo.authors ALTER COLUMN city SET DATA TYPE character varying(40);

-- 'Creating index aunmind on dbo.authors'
CREATE INDEX aunmind ON dbo.authors (au_lname, au_fname);

-- 'Altering dbo.titleview'

CREATE OR REPLACE VIEW dbo.titleview
AS 
Select title, au_ord, au_lname, price, ytd_sales, pub_id
from dbo.titleauthor  inner join dbo.titles
on titles.title_id = titleauthor.title_id
inner join dbo.authors
on dbo.authors.au_id = dbo.titleauthor.au_id;



-- 'Altering dbo.byroyalty'

CREATE OR REPLACE PROCEDURE dbo.byroyalty (percentage int)
  LANGUAGE 'sql'
AS $BODY$
select au_id from titleauthor
where titleauthor.royaltyper = percentage
$BODY$;

-- 'Altering dbo.reptq1'



-- 'Altering dbo.reptq2'

CREATE OR REPLACE PROCEDURE dbo.reptq2 ()
  LANGUAGE 'sql'
AS $BODY$
SELECT CASE WHEN Grouping(type) = 1 THEN 'ALL' ELSE type END AS type,
  CASE WHEN Grouping(pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
  avg(ytd_sales) AS avg_ytd_sales
  FROM titles
  WHERE pub_id IS NOT NULL
  GROUP BY pub_id, type 
$BODY$;

-- 'Altering dbo.reptq3'

CREATE OR REPLACE PROCEDURE dbo.reptq3(
	lolimit money,
	hilimit money,
	type character)
LANGUAGE 'sql'
AS $BODY$
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	count(title_id) as cnt
from titles
where price > lolimit AND price < hilimit AND type =  type OR type LIKE '%cook%'
  GROUP BY pub_id, type
$BODY$;

-- 'Adding constraints to dbo.authors'
ALTER TABLE dbo.authors ALTER COLUMN phone SET DEFAULT ('UNKNOWN');

-- 'Adding constraints to dbo.publishers'
ALTER TABLE dbo.publishers ALTER COLUMN country SET DEFAULT ('USA');

-- 'Adding constraints to dbo.titles'
ALTER TABLE dbo.titles ALTER COLUMN type SET DEFAULT ('UNDECIDED');

-- 'Adding foreign keys to dbo.sales'
-- 'Adding foreign keys to dbo.sales'
ALTER TABLE dbo.sales ADD CONSTRAINT FK_Sales_Stores FOREIGN KEY (stor_id) REFERENCES dbo.stores (stor_id);
ALTER TABLE dbo.sales ADD CONSTRAINT FK_Sales_Title FOREIGN KEY (title_id) REFERENCES dbo.titles (title_id);

