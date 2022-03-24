
DROP INDEX if exists aunmind on dbo.authors;
ALTER TABLE dbo.authors MODIFY COLUMN au_lname character varying(80) NOT NULL;
ALTER TABLE dbo.authors MODIFY COLUMN au_fname  character varying(80) NOT NULL;
ALTER TABLE dbo.authors MODIFY COLUMN phone character varying(40) NOT NULL;
ALTER TABLE dbo.authors MODIFY COLUMN address  character varying(80) NULL;
ALTER TABLE dbo.authors MODIFY COLUMN city character varying(40) NULL;

-- 'Creating index aunmind on dbo.authors'

CREATE INDEX aunmind ON dbo.authors (au_lname, au_fname);

ALTER TABLE dbo.roysched ADD roysched_id INT PRIMARY KEY AUTO_INCREMENT;
ALTER TABLE dbo.discounts ADD discount_id INT PRIMARY KEY AUTO_INCREMENT;
-- 'Adding constraints to dbo.authors'
ALTER TABLE dbo.authors ALTER COLUMN phone SET DEFAULT ('UNKNOWN');

-- 'Adding constraints to dbo.publishers'
ALTER TABLE dbo.publishers ALTER COLUMN country SET DEFAULT ('USA');
ALTER TABLE dbo.publishers MODIFY COLUMN pub_name varchar(100) NOT NULL;
-- 'Adding constraints to dbo.titles'
ALTER TABLE dbo.titles ALTER COLUMN type SET DEFAULT ('UNDECIDED');

-- 'Adding foreign keys to dbo.sales'
-- 'Adding foreign keys to dbo.sales'
ALTER TABLE dbo.sales ADD CONSTRAINT FK_Sales_Stores FOREIGN KEY (stor_id) REFERENCES dbo.stores (stor_id);
ALTER TABLE dbo.sales ADD CONSTRAINT FK_Sales_Title FOREIGN KEY (title_id) REFERENCES dbo.titles (title_id);