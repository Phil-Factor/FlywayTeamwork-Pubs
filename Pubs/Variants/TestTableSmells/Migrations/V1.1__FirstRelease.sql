CREATE TYPE dbo.empid FROM char (9) NOT NULL;

CREATE TYPE dbo.tid FROM varchar (6) NOT NULL;

CREATE TYPE dbo.id FROM varchar (11) NOT NULL;


GO


CREATE TABLE dbo.authors (
     /* The authors of the publications. a publication can have one or more author */
 au_id dbo.id -- The key to the Authors Table
        CONSTRAINT UPKCL_auidind PRIMARY KEY (au_id),
     au_lname varchar(40), -- last name of the author
     au_fname varchar(20), -- first name of the author
     phone char(12) -- the author's phone number
        CONSTRAINT DF__authors__phone__00551192 DEFAULT ('UNKNOWN'),
     address varchar(40), -- the author=s firest line address
     city varchar(20), -- the city where the author lives
     state char(2), -- the state where the author lives
     zip char(5), -- the zip of the address where the author lives
     contract bit -- had the author agreed a contract? 
 );

CREATE TABLE dbo.jobs (
     /* These are the job descriptions and min/max salary level */
 job_id smallint IDENTITY(1,1) -- The surrogate key to the Jobs Table
        CONSTRAINT PK__jobs__6E32B6A51A14E395 PRIMARY KEY (job_id),
     job_desc varchar(50) -- The description of the job
        CONSTRAINT DF__jobs__job_desc__1BFD2C07 DEFAULT ('New Position - title not formalized yet'),
     min_lvl tinyint, -- the minimum pay level appropriate for the job
     max_lvl tinyint -- the maximum pay level appropriate for the job 
 );

CREATE TABLE dbo.publishers (
     /* this is a table of publishers who we distribute books for */
 pub_id char(4) -- The surrogate key to the Publishers Table
        CONSTRAINT UPKCL_pubind PRIMARY KEY (pub_id),
     pub_name varchar(40), -- The name of the publisher
     city varchar(20), -- the city where this publisher is based
     state char(2), -- Thge state where this publisher is based
     country varchar(30) -- The country where this publisher is based
        CONSTRAINT DF__publisher__count__0519C6AF DEFAULT ('USA') 
 );

CREATE TABLE dbo.stores (
     /* these are all the stores who are our customers */
 stor_id char(4) -- The primary key to the Store Table
        CONSTRAINT UPK_storeid PRIMARY KEY (stor_id),
     stor_name varchar(40), -- The name of the store
     stor_address varchar(40), -- The first-line address of the store
     city varchar(20), -- The city in which the store is based
     state char(2), -- The state where the store is base
     zip char(5) -- The zipt code for the store 
 );

CREATE TABLE dbo.discounts (
     /* These are the discounts offered by the sales people for bulk orders */
 discounttype varchar(40), -- The type of discount
     stor_id char(4) -- The store that has the discount
        CONSTRAINT FK__discounts__stor___173876EA FOREIGN KEY (stor_id)
               REFERENCES dbo.stores (stor_id),
     lowqty smallint, -- The lowest order quantity for which the discount applies
     highqty smallint, -- The highest order quantity for which the discount applies
     discount decimal(4,2) -- the percentage discount 
 );

CREATE TABLE dbo.employee (
     /* An employee of any of the publishers */
 emp_id dbo.empid -- The key to the Employee Table
        CONSTRAINT PK_emp_id PRIMARY KEY (emp_id),
     fname varchar(20), -- first name
     minit char(1), -- middle initial
     lname varchar(30), -- last name
     job_id smallint -- the job that the employee does
        CONSTRAINT DF__employee__job_id__24927208 DEFAULT ((1)) 
        CONSTRAINT FK__employee__job_id__25869641 FOREIGN KEY (job_id)
               REFERENCES dbo.jobs (job_id),
     job_lvl tinyint -- the job level
        CONSTRAINT DF__employee__job_lv__267ABA7A DEFAULT ((10)),
     pub_id char(4) -- the publisher that the employee works for
        CONSTRAINT DF__employee__pub_id__276EDEB3 DEFAULT ('9952') 
        CONSTRAINT FK__employee__pub_id__286302EC FOREIGN KEY (pub_id)
               REFERENCES dbo.publishers (pub_id),
     hire_date datetime -- the date that the employeee was hired
        CONSTRAINT DF__employee__hire_d__29572725 DEFAULT (getdate()) 
 );

CREATE TABLE dbo.pub_info (
     /* this holds the special information about every publisher */
 pub_id char(4) -- The foreign key to the publisher
        CONSTRAINT UPKCL_pubinfo PRIMARY KEY (pub_id) 
        CONSTRAINT FK__pub_info__pub_id__20C1E124 FOREIGN KEY (pub_id)
               REFERENCES dbo.publishers (pub_id),
     logo image, -- the publisher's logo
     pr_info text -- The blurb of this publisher 
 );

CREATE TABLE dbo.titles (
      title_id dbo.tid
        CONSTRAINT UPKCL_titleidind PRIMARY KEY (title_id),
     title varchar(80),
     type char(12)
        CONSTRAINT DF__titles__type__07F6335A DEFAULT ('UNDECIDED'),
     pub_id char(4)
        CONSTRAINT FK__titles__pub_id__08EA5793 FOREIGN KEY (pub_id)
               REFERENCES dbo.publishers (pub_id),
     price money,
     advance money,
     royalty int,
     ytd_sales int,
     notes varchar(200),
     pubdate datetime
        CONSTRAINT DF__titles__pubdate__09DE7BCC DEFAULT (getdate()) 
 );

CREATE TABLE dbo.roysched (
     /* this is a table of the authors royalty schedule */
 title_id dbo.tid -- The title to which this applies
        CONSTRAINT FK__roysched__title___15502E78 FOREIGN KEY (title_id)
               REFERENCES dbo.titles (title_id),
     lorange int, -- the lowest range to which the royalty applies
     hirange int, -- the highest range to which this royalty applies
     royalty int -- the royalty 
 );

CREATE TABLE dbo.sales (
     /* these are the sales of every edition of every publication */
 stor_id char(4) -- The store for which the sales apply
        CONSTRAINT FK__sales__stor_id__1273C1CD FOREIGN KEY (stor_id)
               REFERENCES dbo.stores (stor_id),
     ord_num varchar(20), -- the reference to the order
     ord_date datetime, -- the date of the order
     qty smallint, -- the quantity ordered
     payterms varchar(12), -- the pay terms
     title_id dbo.tid -- foreign key to the title
        CONSTRAINT FK__sales__title_id__1367E606 FOREIGN KEY (title_id)
               REFERENCES dbo.titles (title_id) ,
     CONSTRAINT UPKCL_sales PRIMARY KEY (stor_id,ord_num,title_id)
 );

CREATE TABLE dbo.titleauthor (
     /* this is a table that relates authors to publications, and gives their order of listing and royalty */
 au_id dbo.id -- Foreign key to the author
        CONSTRAINT FK__titleauth__au_id__0CBAE877 FOREIGN KEY (au_id)
               REFERENCES dbo.authors (au_id),
     title_id dbo.tid -- Foreign key to the publication
        CONSTRAINT FK__titleauth__title__0DAF0CB0 FOREIGN KEY (title_id)
               REFERENCES dbo.titles (title_id),
     au_ord tinyint, --  the order in which authors are listed
     royaltyper int -- the royalty percentage figure ,
     CONSTRAINT UPKCL_taind PRIMARY KEY (au_id,title_id)
 );

GO
/* Create the trigger dbo.employee_insupd */
CREATE TRIGGER [dbo].[employee_insupd]
ON [dbo].[employee]
FOR insert, UPDATE
AS
--Get the range of level for this job type from the jobs table.
declare @min_lvl tinyint,
   @max_lvl tinyint,
   @emp_lvl tinyint,
   @job_id smallint
select @min_lvl = min_lvl,
   @max_lvl = max_lvl,
   @emp_lvl = i.job_lvl,
   @job_id = i.job_id
from employee e, jobs j, inserted i
where e.emp_id = i.emp_id AND i.job_id = j.job_id
IF (@job_id = 1) and (@emp_lvl <> 10)
begin
   raiserror ('Job id 1 expects the default level of 10.',16,1)
   ROLLBACK TRANSACTION
end
ELSE
IF NOT (@emp_lvl BETWEEN @min_lvl AND @max_lvl)
begin
   raiserror ('The level for job_id:%d should be between %d and %d.',
      16, 1, @job_id, @min_lvl, @max_lvl)
   ROLLBACK TRANSACTION
end


GO
/* Create the stored procedure dbo.reptq2 */
CREATE PROCEDURE [dbo].[reptq2] AS
select 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(ytd_sales) as avg_ytd_sales
from titles
where pub_id is NOT NULL
group by pub_id, type with rollup


GO
/* Create the stored procedure dbo.reptq1 */
CREATE PROCEDURE [dbo].[reptq1] AS
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(price) as avg_price
from titles
where price is NOT NULL
group by pub_id with rollup
order by pub_id


GO
/* Create the stored procedure dbo.byroyalty */
CREATE PROCEDURE [dbo].[byroyalty] @percentage int
AS
select au_id from titleauthor
where titleauthor.royaltyper = @percentage


GO
/* Create the stored procedure dbo.reptq3 */
CREATE PROCEDURE [dbo].[reptq3] @lolimit money, @hilimit money,
@type char(12)
AS
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	count(title_id) as cnt
from titles
where price >@lolimit AND price <@hilimit AND type = @type OR type LIKE '%cook%'
group by pub_id, type with rollup

